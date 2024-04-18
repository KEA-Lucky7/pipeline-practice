FROM nginx

COPY index.html /usr/share/nginx/html/index.html

# Nginx 서버 실행
CMD ["nginx", "-g", "daemon off;"]