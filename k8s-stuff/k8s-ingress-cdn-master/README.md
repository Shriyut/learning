# k8s-ingress-cdn

Trying to enable cdn with container native load balancing for my private GKE cluster - POC

Create a namespace

Reserve a static IP before creating ingress

gcloud compute addresses create cdn-how-to-address --global

This address is referred in the annotations section of ingress.yaml

Create deployment -> backend-config -> service -> reserve a ststic ip(global) -> ingress

kubectl get ingress my-ingress --output yaml --namespace cdn-how-to

this command will provide the load balancer ip

wait for sometime then open a new tab in your browser

enter http://( lb ip):80

Requests are routed to the Pod on the target port specified in my-service. In this exercise, the Pod target port is 8080

Here we only have one backend pod

Things to implement:

A frontend pod that routes traffic to middleware pod and then to backend pod using container native load balancing with cdn enabled.
