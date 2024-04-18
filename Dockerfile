FROM nginx

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

# Nginx 서버 실행
CMD ["nginx", "-g", "daemon off;"]