import boto3
from boto3 import resource
from boto3.dynamodb.conditions import Key


def create_table(table_name):
    ''' create a table and return the table object'''
    dynamodb_resource = resource('dynamodb')
    # to do
    # check the sample code https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStarted.Python.01.html
    # create the greetings table with attributes (gid, date, content, timestamp), where timestamp is the time the record saved to DynamoDb, 
    # different from the greeting date
    # return the table object
    table = dynamodb.create_table(
        TableName=table_name,
        KeySchema=[
            {
                'AttributeName': 'gid',
                'KeyType': 'HASH'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'gid',
                'AttributeType': 'N'
            },
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 10,
            'WriteCapacityUnits': 10
        }
    )

    table.meta.client.get_waiter('table_exists').wait(TableName='greetings')
    print (table.item_count)
    print ("Table status:", mytable.table_status)


def get_table(table_name):
    dynamodb_resource = resource('dynamodb')
    # to do
    # return the table object, when the table is already created, 
    # otherwise create and return the table object
    table = None
    try:
        table = dynamodb_resource.Table(table_name)
    except:
        print ("cannot get the table", table_name)
    finally:
        return table
    

def read_table_item(table, pk_name, pk_value):
    
    # to do
    """
    table is the object returned by get_table
    Return item read by primary key.
    """
    table = get_table(table)
    response = table.get_item(Key={pk_name: pk_value})
    return response


def add_item(table, col_dict):
    """
    Add one item (row) to table. col_dict is a dictionary {col_name: value}.
    """
    tabledata = get_table(table)
    response = table.put_item(Item=col_dict)

    return response


def delete_item(table, pk_name, pk_value):
    """
    Delete an item (row) in table from its primary key.
    """
    tabledata = get_table(table)
    response = table.delete_item(Key={pk_name: pk_value})

    return repsonse

if __name__ == '__main__'
    create_table("greetings")
