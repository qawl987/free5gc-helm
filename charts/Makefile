uninstall:
	-microk8s kubectl delete all --all --namespace=free5gc
	-microk8s kubectl delete pvc --all --namespace=free5gc
	-microk8s kubectl delete pv free5gc-pv-mongo
	-microk8s kubectl delete pv free5gc-pv-cert
	-helm -n free5gc uninstall free5gc-v1
	-helm -n free5gc uninstall ueransim-v1
all:
	-microk8s kubectl apply -f persistent-vol-for-mongodb.yaml
	-microk8s kubectl apply -f persistent-vol-for-cert.yaml
	-helm -n free5gc install free5gc-v1 ./free5gc/
	-helm -n free5gc install ueransim-v1 ./ueransim/
core:
	-microk8s kubectl apply -f persistent-vol-for-mongodb.yaml
	-microk8s kubectl apply -f persistent-vol-for-cert.yaml
	-helm -n free5gc install free5gc-v1 ./free5gc/
ue:
	-helm -n free5gc install ueransim-v1 ./ueransim/