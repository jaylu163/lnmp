

### nginx1.13.9编译安装 php7.2.3编译安装 ###


/var/www/test.conf文件的配置测试用

server {
        server_name stage.localhost;
        listen 8080 ;
        root /var/www;
        index index.html index.htm index.php;

        access_log /var/log/nginx/test-access.log;
        error_log  /var/log/nginx/test-error.log;

        if (!-e $request_filename) {
                rewrite ^/(.*)$ /index.php?/$1 last;
                break;
        }

        location  ~ .*.php?$ {
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME   $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}



