"""Add user authentication and URL management

Revision ID: 87f471c5b7d7
Revises: 
Create Date: 2024-08-14 00:46:19.678711
"""

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = '87f471c5b7d7'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### Create the user table ###
    op.create_table('user',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('username', sa.String(length=150), nullable=False),
        sa.Column('email', sa.String(length=150), nullable=False),
        sa.Column('password_hash', sa.String(length=256), nullable=False),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('email'),
        sa.UniqueConstraint('username')
    )

    # ### Create the url table ###
    op.create_table('url',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('original_url', sa.String(512), nullable=False),
        sa.Column('short_url', sa.String(6), unique=True, nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column('date_last_used', sa.DateTime(), nullable=True),  # Ensure this column is included
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['user_id'], ['user.id'], ondelete='CASCADE')
    )

    # ### end Alembic commands ###


def downgrade():
    # ### Drop the url table ###
    op.drop_table('url')

    # ### Drop the user table ###
    op.drop_table('user')

    # ### end Alembic commands ###
