FROM nginx:latest

COPY webapp /usr/share/nginx/html
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# 포트 80 열기
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]