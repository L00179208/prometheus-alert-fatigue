from flask import Blueprint, render_template, redirect, url_for, request, flash
from flask_login import login_user, login_required, logout_user, current_user
from .models import User, URL  # Ensure User is imported here
from . import db
import string, random
from datetime import datetime


main_blueprint = Blueprint('main', __name__)

def generate_short_url():
    characters = string.ascii_letters + string.digits
    short_url = ''.join(random.choice(characters) for _ in range(6))
    return short_url

@main_blueprint.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')

        user = User.query.filter_by(email=email).first()
        if user:
            flash('Email address already exists')
            return redirect(url_for('main.signup'))

        new_user = User(username=username, email=email)
        new_user.set_password(password)
        db.session.add(new_user)
        db.session.commit()

        login_user(new_user)
        return redirect(url_for('main.index'))

    return render_template('signup.html')

@main_blueprint.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        user = User.query.filter_by(email=email).first()

        if not user or not user.check_password(password):
            flash('Please check your login details and try again.')
            return redirect(url_for('main.login'))

        login_user(user)
        return redirect(url_for('main.index'))

    return render_template('login.html')

@main_blueprint.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('main.index'))

@main_blueprint.route('/')
def index():
    return render_template('index.html')

@main_blueprint.route('/shorten', methods=['POST'])
@login_required
def shorten_url():
    original_url = request.form.get('original_url')
    short_url = generate_short_url()

    new_url = URL(original_url=original_url, short_url=short_url, user=current_user)
    db.session.add(new_url)
    db.session.commit()

    return redirect(url_for('main.my_urls'))

@main_blueprint.route('/<short_url>')
def redirect_to_url(short_url):
    url = URL.query.filter_by(short_url=short_url).first_or_404()
    url.date_last_used = datetime.utcnow()
    db.session.commit()
    return redirect(url.original_url)

@main_blueprint.route('/my_urls')
@login_required
def my_urls():
    urls = URL.query.filter_by(user=current_user).all()
    return render_template('my_urls.html', urls=urls)
