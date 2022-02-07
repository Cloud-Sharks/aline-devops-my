import pytest
import sqlalchemy as db
from sqlalchemy import text, MetaData

def test_connect_as_root():
# specify db config
    config = {
        'host' : 'localhost',
        'port' : 3307,
        'user' : 'root',
        'password' : 'root',
        'database' : 'alinedb'
    }

    db_user = config.get('user')
    db_pwd = config.get('password')
    db_host = config.get('host')
    db_port = config.get('port')
    db_name = config.get('database')

    # specify connection string
    connection_str = f'mysql+pymysql://{db_user}:{db_pwd}@{db_host}:{db_port}/{db_name}'
    # connect to database
    engine = db.create_engine(connection_str)
    connection = engine.connect()
    # test root can access db by checking if first table is 'account'
    m = MetaData()
    m.reflect(engine)
    first_table = next(iter(m.tables))
    assert first_table == "account"

def test_connect_as_user():
# specify db config
    config = {
        'host' : 'localhost',
        'port' : 3307,
        'user' : 'user',
        'password' : 'pwd',
        'database' : 'alinedb'
    }

    db_user = config.get('user')
    db_pwd = config.get('password')
    db_host = config.get('host')
    db_port = config.get('port')
    db_name = config.get('database')

    # specify connection string
    connection_str = f'mysql+pymysql://{db_user}:{db_pwd}@{db_host}:{db_port}/{db_name}'
    # connect to database
    engine = db.create_engine(connection_str)
    connection = engine.connect()
    # test user can access db by checking if first table is 'account'
    m = MetaData()
    m.reflect(engine)
    first_table = next(iter(m.tables))
    assert first_table == "account"