from flask import Blueprint, request, redirect, render_template
from .models import URL
from . import db
import string
import random

main_blueprint = Blueprint('main', __name__)

def generate_short_url():
    characters = string.ascii_letters + string.digits
    short_url = ''.join(random.choice(characters) for _ in range(6))
    return short_url

@main_blueprint.route('/')
def index():
    return render_template('index.html')

@main_blueprint.route('/shorten', methods=['POST'])
def shorten_url():
    original_url = request.form.get('original_url')
    short_url = generate_short_url()

    # Save to the database
    new_url = URL(original_url=original_url, short_url=short_url)
    db.session.add(new_url)
    db.session.commit()

    return f"Shortened URL: {short_url}"

@main_blueprint.route('/<short_url>')
def redirect_to_url(short_url):
    url = URL.query.filter_by(short_url=short_url).first_or_404()
    return redirect(url.original_url)

@main_blueprint.route('/test')
def test():
    return "Test route is working!"
