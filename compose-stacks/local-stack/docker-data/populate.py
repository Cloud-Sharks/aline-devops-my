from importlib.machinery import SourceFileLoader
import requests
import os

try:
    # get defined methods
    populate_bank = SourceFileLoader('bank_producer', 'aline_files/aline-bank-microservice-my/python-data-producer/bank_producer.py').load_module()
    populate_branch = SourceFileLoader('branch_producer', 'aline_files/aline-bank-microservice-my/python-data-producer/branch_producer.py').load_module()
    populate_applicant = SourceFileLoader('applicant_producer', 'aline_files/aline-underwriter-microservice-my/python-data-producer/applicant_producer.py').load_module()
    populate_user = SourceFileLoader('user_producer', 'aline_files/aline-user-microservice-my/python-data-producer/user_producer.py').load_module()
    populate_transaction = SourceFileLoader('transaction_producer', 'aline_files/aline-transaction-microservice-my/python-data-producer/transaction_producer.py').load_module()

    try:
        # login to api services to get bearer token
        login_info = {
            'username' : 'adminUser',
            'password' : 'Password*8'
        }
        # login_url = 'http://localhost:8070/login'
        login_url = f"{os.environ.get('USER_URL')}/login"
        login_response = requests.post(login_url, json=login_info)
        bearer_token = login_response.headers['Authorization']
        auth = {'Authorization' : bearer_token}

        print('Number of banks: ')
        bank_entries = int(input())
        print('Number of branches (<= banks): ')
        branch_entries = int(input())
        print('Number of applications: ')
        app_entries = int(input())

        # execute methods to populate db
        print(f"Populating {bank_entries} banks")
        populate_bank.populate_bank(auth, bank_entries)
        print(f"Populating {branch_entries} branches")
        populate_branch.populate_branch(auth, branch_entries)
        print(f"Populating {app_entries} applications")
        app_out = populate_applicant.populate_applicant(auth, app_entries)
        print("Populating users")
        populate_user.populate_user(auth, app_out[0])
        print("Populating transactions")
        populate_transaction.populate_transaction(auth, app_out[1])
    except Exception as e:
        print('Error populating')
        
except Exception as e:
    print('Error loading methods')

