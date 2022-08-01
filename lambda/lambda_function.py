import sys
import logging
import pymysql
import dbinfo
import json
import boto3

connection = pymysql.connect(host=dbinfo.db_host,port=dbinfo.db_port,user=dbinfo.db_username,passwd=dbinfo.db_password,db=dbinfo.db_name)

def lambda_handler(event, context) :
    
    # ses 사용 및 리전 설정
    client = boto3.client('ses', region_name="ap-northeast-2")
    
    # mail message
    subject = "[xx닷컴] 톰브라운 에디션 당첨 안내"
    body = """
    <br>
    안녕하세요, xx닷컴입니다.<br>
    <br>
    응모하신 [갤럭시 Z 플립4/폴드4 톰브라운 에디션 한정 판매]에 당첨되셨습니다.<br>
    진심으로 축하드립니다.<br>
    <br>
    아래 유의사항 및 구매 기간을 확인하시고 xx닷컴 로그인 후 구매하여 주시기 바랍니다.<br>
    <br>
    ※ 유의사항<br>
    1. 1인 1대만 구매 가능합니다.<br>
    2. 당첨자 구매 기간 이후에는 구매가 불가합니다.<br>
    3. 구매 진행 시 응모하신 휴대폰 번호를 입력하시기 바랍니다.<br>
    """
    message = {"Subject" : {"Data" : subject}, "Body" : {"Html" : {"Data" : body}}}
    
    # DB 연결
    cursor = connection.cursor()
    
    # 당첨자 추첨하여 winner table에 insert
    cursor.execute("INSERT INTO winner SELECT * FROM user ORDER BY RAND() LIMIT 2")
    connection.commit()
    
    # 메일을 보내기 위해 winner table에서 당첨자 email 가져오기
    cursor.execute("SELECT email FROM winner")
    
    rows = cursor.fetchall()
    
    for row in rows:
        response = client.send_email(Source = dbinfo.db_email, Destination = {"ToAddresses" : [row[0]],}, Message = message)
    
    cursor.close()
    
    return {
        'statusCode': 200,
    }