from flask import Flask
from werkzeug.exceptions import NotFound
from flask import make_response
import json

import dynamo # the code you finished for Part I


app = Flask(__name__)

# code here to open the DynamoDB table. If the table is not there, create it
# to do

#dynamodb_client = boto3.client('dynamodb')
#table_name = 'greetings'
#existing_tables = dynamodb_client.list_tables()['TableNames']

#if table_name not in existing_tables:
 #   create_table()
#else:
#    get_table()

def root_dir():
    """ Returns root director for this project """
    return os.path.dirname(os.path.realpath(__file__ + '/..'))

def nice_json(arg):
    response = make_response(json.dumps(arg, sort_keys = True, indent=4))
    response.headers['Content-type'] = "application/json"
    return response


@app.route("/", methods=['GET'])
def hello():
    return nice_json({
        "uri": "/",
        "subresource_uris": {
            "greetings": "/greetings",
            "add_greeting": "/greetings/<id>/<date>/<content>",
        }
    })

@app.route("/greetings", methods=['GET'])
def greetings():
    # return all greetings records in json format
    # to do
    list = []
    table=dynamo.get_table("greetings")
    tablecontent=table.scan()
    for content in tablecontent['Items']:
        list.append(content)
    return nice_json(list)

@app.route("/addgreeting/<gid>/<date>/<content>", methods=['POST', 'PUT'])
def add_greeting(gid, date, content):
    # use the methods in dynamo.py and add a greeting to DynamoDB
    # to do
    table_dict={'gid':gid,'date':date,'content':content}
    return nice_json(dynamo.add_item("greetings", table_dict))

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5001, debug=True)
