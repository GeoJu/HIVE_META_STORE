#!bin/bash
####################################################
## Analyze_Partition Table
## 기능 : 전체 파티션 테이블 analyze 쿼리문 생성 및 analyze_sql -> analyze_history 이동
##      partition table key type에 따른 쿼리문 생성 분류 자동화 
####################################################


source /home/ETL_SRC/analyze_job/analyze_util/analyze_class.sh

mv ${ANALYZE_SQL}/analyze_stat_part/* ${ANALYZE_SQL}/analyze_stat_history/ 2>&1

today=$(date -d now +'%Y%m%d')
system=$(get_system_name)


IFS=$'\n' table_list=(`psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME} -At <<!
select DB.NAME", TBL."TBL_NAME" FROM "TBLS" TBL, "DBS" DB 
                               WHERE TBL."DB_ID" = DB."DB_ID"
							     AND TBL."TBL_ID" NOT IN (SELECT "TBL_ID" FROM "PARTITIONS" GROUP BY "TBL_ID")
								 AND DB."NAME" IN ${SYSTEM}
		                         AND DB."DB_LOCATION_URI" LIKE '%{}%'
						   OREDER BY DB."NAME";
!`)