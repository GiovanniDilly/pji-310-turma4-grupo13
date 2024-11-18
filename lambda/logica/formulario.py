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

def formulario_create(event, context):
    
    try:
    
        try:
            data_received = json.loads(event['body'])
        except:
            return {
            'statusCode': 400,
            'body': "Erro ao tentar obter os parâmetros de \"body\". Certifique que foram passados os parâmetros formatados do JSON."
        }
        
        formulario = avulDB["formulario"]

        dado_inserido = formulario.insert_one(data_received)
        
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
            'body': "Erro interno do servidor ao tentar criar o conteúdo para \"formulário\". Tente novamente mais tarde."
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

def formulario_search(event, context):
    
    try:
    
        try:
            pesquisa = json.loads(event['body'])
        except:
            pesquisa = {}
        
            
        formulario = avulDB["formulario"]
        
        
        if bool(pesquisa) == False:
            query = {}
        else:
            query = {}
        
            if "Inspetor" in pesquisa:
                query["Inspetor"] = pesquisa["Inspetor"]
                
            if "Setor" in pesquisa:
                query["Setor"] = pesquisa["Setor"]
            
            if "Atividade" in pesquisa:
                query["Atividade"] = pesquisa["Atividade"]
            
            if "Data Inicio" in pesquisa:
                query["Data"] = { "$gte": pesquisa["Data Inicio"] }
                
            if "Data Fim" in pesquisa:
                if "Data" in query:
                    query["Data"]["$lte"] = pesquisa["Data Fim"]
                else:    
                    query["Data"] = { "$lte": pesquisa["Data Fim"] }
                    
            
            if bool(query) == False:
                return {
                    'statusCode': 404,
                    'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\". Certifique que foram passados os parâmetros corretos no JSON."
                }
        
        resultado = formulario.find(query)
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


def formulario_delete(event, context):
    
    try:
    
        try:
            para_deletar = json.loads(event['body'])
        except:
            return {
            'statusCode': 400,
            'body': "Erro ao tentar obter os parâmetros de \"body\". Certifique que foram passados os parâmetros formatados do JSON."
        }
        
            
        formulario = avulDB["formulario"]
        
        if bool(para_deletar) == False:
            return {
                'statusCode': 404,
                'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\", pois estão vazios. Certifique de preencher parâmetros corretos no JSON."
            }
        else:
            query = {}
            
            if "Usuario" in para_deletar:
                query["Usuario"] = para_deletar["Usuario"]
                
            if "Setor" in para_deletar:
                query["Setor"] = para_deletar["Setor"]
            
            if "Atividade" in para_deletar:
                query["Atividade"] = para_deletar["Atividade"]
            
            if "Data Inicio" in para_deletar:
                query["Data"] = { "$gte": para_deletar["Data Inicio"] }
                
            if "Data Fim" in para_deletar:
                if "Data" in query:
                    query["Data"]["$lte"] = para_deletar["Data Fim"]
                else:    
                    query["Data"] = { "$lte": para_deletar["Data Fim"] }
            
            if bool(query) == False:
                return {
                    'statusCode': 404,
                    'body': "Erro ao tentar pesquisar com os parâmetros passados de \"body\". Certifique que foram passados os parâmetros corretos no JSON."
                }
        
        formularios_deletados = formulario.find(query)
        lista_forms_deletados = list(formularios_deletados)
        
        resultado = formulario.delete_many(query)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
            },
            'body': bson_dumps({
                "Resposta": f"{resultado.deleted_count} formulário(s) deletado(s).",
                "Deletados": lista_forms_deletados
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