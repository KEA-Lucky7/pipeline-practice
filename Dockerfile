FROM nginx:latest

# 저자 정보
LABEL maintainer="lucky7"

# Nginx의 기본 설정 파일을 삭제하고 사용자 정의 설정 파일을 추가
RUN rm /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/conf.d

# 호스트 시스템에서 이미지 내부로 웹 사이트 파일 복사
COPY html/ /usr/share/nginx/html/

# 포트 80 열기
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]