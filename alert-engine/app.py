from flask import Flask, request, jsonify
import json
import requests
import time
import os
from collections import deque
from prometheus_client import start_http_server, Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

# Load environment variables
PROMETHEUS_RELOAD_URL = os.getenv('PROMETHEUS_RELOAD_URL', 'http://localhost:9090/-/reload')
SLACK_WEBHOOK_URL = os.getenv('SLACK_WEBHOOK_URL', 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL')
PROMETHEUS_RULES_FILE = os.getenv('PROMETHEUS_RULES_FILE', '/etc/prometheus/rules/alert.rules.yml')

# Start the Prometheus metrics server on port 8000
start_http_server(8000)

# Create a Counter to count the number of alerts processed
alerts_processed = Counter('alerts_processed_total', 'Total number of alerts processed')

# Store timestamps of the last 10 alerts for rate limiting
alert_timestamps = deque(maxlen=10)

# Store seen alerts for deduplication
seen_alerts = set()

def rate_limit():
    """
    Rate limiting to prevent forwarding too many alerts in a short period.
    """
    now = time.time()
    if len(alert_timestamps) == alert_timestamps.maxlen and now - alert_timestamps[0] < 60:
        return True  # Rate limit hit
    alert_timestamps.append(now)
    return False

def is_duplicate(alert):
    """
    Deduplication to prevent forwarding the same alert multiple times.
    """
    alert_id = f"{alert['labels']['alertname']}-{alert['labels'].get('instance', '')}"
    if alert_id in seen_alerts:
        return True
    seen_alerts.add(alert_id)
    return False

@app.route('/alert', methods=['POST'])
def alert():
    """
    Endpoint to receive alerts from Prometheus and apply filtering logic.
    """
    alert_data = request.get_json()

    # Check if the data is parsed correctly and contains the expected structure
    if alert_data is None or 'alerts' not in alert_data:
        return jsonify({"status": "error", "message": "Invalid data format"}), 400

    # Apply filtering logic
    filtered_alerts = filter_alerts(alert_data)

    if filtered_alerts:
        # Increment the alert counter for each processed alert
        alerts_processed.inc(len(filtered_alerts))

        # Forward the filtered alerts (e.g., to Slack)
        forward_alerts(filtered_alerts)

    return jsonify({"status": "received"}), 200

def filter_alerts(alert_data):
    """
    Filters the alerts based on severity and deduplication.
    """
    filtered_alerts = []
    for alert in alert_data['alerts']:
        if alert['labels']['severity'] == 'critical' and not is_duplicate(alert):
            filtered_alerts.append(alert)
    return filtered_alerts

def forward_alerts(alerts):
    """
    Forwards the filtered alerts to Slack, considering rate limiting.
    """
    if rate_limit():
        print("Rate limit hit. Not forwarding alerts.")
        return

    for alert in alerts:
        severity = alert['labels']['severity']
        if severity == 'critical':
            message = {
                "text": f"Critical Alert: {alert['annotations']['summary']}\nDescription: {alert['annotations']['description']}"
            }
            response = requests.post(SLACK_WEBHOOK_URL, json=message)
            print(f"Slack response: {response.status_code}")
        elif severity == 'warning':
            print(f"Warning Alert: {alert['annotations']['summary']} - Logging for later review.")
            # Implement logging or another action for warnings

@app.route('/metrics')
def metrics():
    """
    Expose the Prometheus metrics at the /metrics endpoint.
    """
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route('/analyze', methods=['POST'])
def analyze():
    """
    Endpoint to receive and analyze Terraform plans.
    """
    tfplan = request.files['tfplan']
    plan = json.load(tfplan)
    issues = analyze_terraform_plan(plan)
    
    if issues:
        print(f"Issues found: {issues}")
        adjust_prometheus_rules(issues)

    return jsonify({"issues": issues}), 200

def analyze_terraform_plan(plan):
    """
    Analyze Terraform plan to identify potential configuration issues.
    """
    issues = []
    for resource in plan['planned_values']['root_module']['resources']:
        if resource['type'] == 'aws_instance':
            if 'vpc_security_group_ids' not in resource['values']:
                issues.append(f"Instance {resource['name']} is missing security groups!")
            # Add more checks as needed
    return issues

def adjust_prometheus_rules(issues):
    """
    Adjust Prometheus alert rules based on identified Terraform plan issues.
    """
    # Load the existing rules
    with open(PROMETHEUS_RULES_FILE, 'r') as f:
        rules = f.read()

    # Example: Adjusting rules based on detected issues
    for issue in issues:
        if "missing security groups" in issue:
            # Suppose there's a rule related to security groups; disable or adjust it
            rules = rules.replace("alert: SecurityGroupMissing\n", "# alert: SecurityGroupMissing\n")
            rules += f"\n# Adjusted rule due to detected issue: {issue}\n"

    # Write the adjusted rules back
    with open(PROMETHEUS_RULES_FILE, 'w') as f:
        f.write(rules)

    # Optional: Reload Prometheus configuration to apply new rules
    reload_prometheus()

def reload_prometheus():
    """
    Function to reload Prometheus configuration after adjusting rules.
    """
    try:
        response = requests.post(PROMETHEUS_RELOAD_URL)
        if response.status_code == 200:
            print("Prometheus configuration reloaded successfully.")
        else:
            print(f"Failed to reload Prometheus configuration. Status code: {response.status_code}")
    except Exception as e:
        print(f"Error reloading Prometheus configuration: {str(e)}")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000, debug=True)
