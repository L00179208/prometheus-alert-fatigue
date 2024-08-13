from . import db

class URL(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    original_url = db.Column(db.String(512), nullable=False)
    short_url = db.Column(db.String(6), unique=True, nullable=False)
    date_created = db.Column(db.DateTime, default=db.func.now())
