"""create an address table

Revision ID: c0560e47caa8
Revises: 
Create Date: 2019-08-15 16:48:28.730981

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'c0560e47caa8'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
        op.create_table(
                       'address',
                        sa.Column('id', sa.Integer, primary_key=True),
                        sa.Column('address', sa.String(50), nullable=False),
                        sa.Column('city', sa.String(50), nullable=False),
                        sa.Column('state', sa.String(20), nullable=False),
        )

def downgrade():
	try:
		op.drop_table('address')
	except:
		pass

