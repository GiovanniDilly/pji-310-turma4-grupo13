from bson.json_util import dumps as bson_dumps
from bson.objectid import ObjectId
import json
from datetime import datetime, date
import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:27017/")

avulDB = myclient["avul-db"]

hora_zero = datetime.min.time()
def __data__(data):
    return datetime.combine(data, hora_zero)

data_zero = datetime.min.date()
def __hora__(hora):
    return datetime.combine(data_zero, hora)


def inspetor_create(event, context):
    
    try:
        
        try:
            data_received = json.loads(event['body'])
        except:
            return {
                'statusCode': 400,
                'body': "Erro ao tentar obter os parâmetros de \"body\". Certifique que foram passados os parâmetros formatados do JSON."
            }
        
        inspetor = avulDB["inspetor"]

        dado_inserido = inspetor.insert_one(data_received)
        
        if dado_inserido.acknowledged:
            
            return {
                'statusCode': 201,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': bson_dumps(dado_inserido.inserted_id),
            }

        else:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': "Erro interno do servidor ao tentar criar o conteúdo para \"inspetor\". Tente novamente mais tarde."
            }
    
    except:
        if True:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': "Erro interno do servidor ao tentar criar o conteúdo. Tente novamente mais tarde."
            }

## --------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------

def inspetor_search(event, context):
    
    try:
    
        try:
            pesquisa = json.loads(event['body'])
        except:
            pesquisa = {}
        
            
        inspetor = avulDB["inspetor"]
        
        if bool(pesquisa) == False:
            query = {}
        else:
            query = {}
            
            if "Nome" in pesquisa:
                query["Nome"] = pesquisa["Nome"]
            
            if "Usuario" in pesquisa:
                query["Usuario"] = pesquisa["Usuario"]
            
            if bool(query) == False:
                return {
                    'statusCode': 404,
                    'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\". Certifique que foram passados os parâmetros corretos no JSON."
                }
            
        resultado = inspetor.find(query)
        resposta_final = bson_dumps(list(resultado))
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': resposta_final,
        }

    except:
        if True:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': "Erro interno do servidor ao tentar recuperar o conteúdo. Tente novamente mais tarde."
            }


## --------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------

def inspetor_delete(event, context):
    
    try:
    
        try:
            para_deletar = json.loads(event['body'])
        except:
            return {
            'statusCode': 400,
            'body': "Erro ao tentar obter os parâmetros de \"body\". Certifique que foram passados os parâmetros formatados do JSON."
        }
        
        
        inspetor = avulDB["inspetor"]
        
        if bool(para_deletar) == False:
            return {
                'statusCode': 404,
                'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\", pois estão vazios. Certifique de preencher parâmetros corretos no JSON."
            }
        else:
            query = {}
            
            if "Nome" in para_deletar:
                query["Nome"] = para_deletar["Nome"]
            
            if "Usuario" in para_deletar:
                query["Usuario"] = para_deletar["Usuario"]
            
            if bool(query) == False:
                return {
                    'statusCode': 404,
                    'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\". Certifique que foram passados os parâmetros corretos no JSON."
                }
        
        inspetores_deletados = inspetor.find(query)
        inspetores_json = list(inspetores_deletados)
        
        resultado = inspetor.delete_many(query)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': bson_dumps({
                "Resposta": f"{resultado.deleted_count} inspetor(es) deletado(s).",
                "Deletados": inspetores_json
            }),
        }

    except:
        if True:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': "Erro interno do servidor ao tentar deletar o conteúdo. Tente novamente mais tarde."
            }

## --------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------
## --------------------------------------------------------------------------------------------------------------------------

def inspetor_update(event, context):
    
    try:
    
        try:
            body = json.loads(event['body'])
            
            pesquisa = body["Pesquisa"]
            atualizacao = body["Atualizacao"]
        except:
            return {
                'statusCode': 400,
                'body': "Erro ao tentar obter os parâmetros de \"body\". Certifique que foram passados os parâmetros formatados do JSON."
            }
        
            
        inspetor = avulDB["inspetor"]
        
        if bool(pesquisa) == False:
            return {
                'statusCode': 404,
                'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\", pois estão vazios. Certifique de preencher parâmetros corretos no JSON."
            }
        else:
            query = {}
            
            if "Nome" in pesquisa:
                query["Nome"] = pesquisa["Nome"]
            
            if "Usuario" in pesquisa:
                query["Usuario"] = pesquisa["Usuario"]
            
            if bool(query) == False:
                return {
                    'statusCode': 404,
                    'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\". Certifique que foram passados os parâmetros corretos no JSON."
                }
        
        inspetor_to_update = inspetor.find_one(query)
        
        if inspetor_to_update == None:
            return {
                'statusCode': 404,
                'body': "Inspetor não encontrado na base de dados."
            }
        
        id_inspetor = inspetor_to_update["_id"]
        query_id = {'_id': id_inspetor}
        
        set_atualizacao = {
            "$set": atualizacao
        }
        
        inspetor.update_one(query_id, set_atualizacao)
        inspetor_to_update = inspetor.find_one(query_id)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': json.dumps({
                "Inspetor Atualizado": bson_dumps(inspetor_to_update)
            }),
        }

    except Exception as e:
        if True:
            return {
                'statusCode': 500,
                'headers': {
                    'Content-Type': 'application/json',
                },
                'body': "Erro interno do servidor ao tentar atualizar o conteúdo. Tente novamente mais tarde." + f"\n {e}"
            }