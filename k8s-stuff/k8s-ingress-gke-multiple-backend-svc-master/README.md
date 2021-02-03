# k8s-ingress-gke-multiple-backend-svc

Useful links for this POC

https://cloud.google.com/kubernetes-engine/docs/concepts/ingress

https://www.nginx.com/resources/wiki/start/topics/examples/full/

https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/

https://www.nginx.com/blog/nginx-plus-kubernetes-google-cloud-platform-pt-2-load-balancing/

https://www.digitalocean.com/community/tutorials/docker-explained-how-to-containerize-and-use-nginx-as-a-proxy

https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts

https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/ingress-path-matching.md


We can also implement this setup using nginx configuration files.
Create a pod with nginx configuration file to route traffic to specific backends
traffic from load balancer will first eneter the nginx pod and then to its destination ( another poc)

1) Create a namespace 

2) Reserve a static global IP

Create deployment -> backend-config -> service -> reserve a ststic ip(global) -> ingress
