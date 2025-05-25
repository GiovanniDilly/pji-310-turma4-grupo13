import json
import os
from datetime import datetime, date
from sqlalchemy import create_engine, text

engine = create_engine(os.getenv("mysql_dsn"))

def avul2_login(event, context):
    
    try:
        try:
            data_received = json.loads(event['body'])
        except:
            return {
                'statusCode': 400,
                'body': "Erro ao tentar obter os parâmetros de \"body\". Certifique que foram passados os parâmetros formatados do JSON."
            }
        
        with engine.connect() as connection:
            
            resu = connection.execute(
                text("SELECT id, nome FROM usuario WHERE nome = :nome AND senha = :senha LIMIT 1"),
                {"nome": data_received["nome"], "senha": data_received["senha"]}
            ).fetchone()
            
            # Achou a pessoa
            if resu:
                id_usuario, nome_usuario = resu[0], resu[1]
                
                return{
                    'statusCode': 200,
                    'headers': {
                        'Content-Type': 'application/json',
                    },
                    'body': json.dumps({
                        "logged_in": True,
                        "id": id_usuario,
                        "nome": nome_usuario,
                    })
                }
            else:
                print("Usuário não encontrado.")
    except:
        return {
            'statusCode': 500,  
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': "Erro interno do servidor ao tentar criar o conteúdo. Tente novamente mais tarde."
        }