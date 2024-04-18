FROM nginx

COPY ./html /usr/share/nginx/html

# Nginx 서버 실행
CMD ["nginx", "-g", "daemon off;"]