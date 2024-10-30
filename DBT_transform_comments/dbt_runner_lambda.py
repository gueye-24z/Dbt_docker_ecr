import subprocess

def lambda_handler(event, context):
    # Exécute DBT dans Lambda
    try:
        result = subprocess.run(["dbt", "run"], capture_output=True, text=True)
        return {
            'statusCode': 200,
            'body': result.stdout
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': str(e)
        }
