{{/* Annotations for Ingress */}}
{{- define "ingress.annotations" }}
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/load-balancer-name: aline-lbn-my
{{- end }}
