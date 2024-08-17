"""Increase length of password_hash column

Revision ID: 81c6ff3a9313
Revises: c5e70eacf10f
Create Date: 2024-08-14 12:32:25.184137

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '81c6ff3a9313'
down_revision = 'c5e70eacf10f'
branch_labels = None
depends_on = None


def upgrade():
    op.alter_column('user', 'password_hash',
                    existing_type=sa.String(length=256),
                    type_=sa.String(length=512),
                    existing_nullable=False)

def downgrade():
    op.alter_column('user', 'password_hash',
                    existing_type=sa.String(length=512),
                    type_=sa.String(length=256),
                    existing_nullable=False)