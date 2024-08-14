
# Deploying Apache Airflow on Kubernetes cluster

The easiest way to deply on k8s with helm chart described [*here*](https://medium.com/@kerrache.massipssa/deploy-apache-airflow-with-kubernetes-8f764a4cc984). 
Chart inclused DB engine (Postgres) and some default values. By default Airflow uses **CeleryExecutor** but it could be changed to **KubernetesExecutor** wihtin values.yaml

Below you find step-by-step manual on deploying Airflow with k8s manifests


## Prerequisites

- Kubernetes cluster
- `kubectl` installed and configured
- A valid `fernet-key` and `sql_alchemy_conn` (in base64 encoding)

## Deployment

- **Apply ConfigMap and Secrets**:

   `
   kubectl apply -f manifests/airflow-configmap.yaml
   `

   ` 
   kubectl apply -f manifests/airflow-secrets.yaml
   `

- **Create PersistentVolumeClaims:**:

   `
   kubectl apply -f manifests/airflow-pvc.yaml
   `

- **Set up RBAC:**:

   `
   kubectl apply -f manifests/airflow-rbac.yaml
   `

- **Deploy Airflow:**:

   `
   kubectl apply -f manifests/airflow-deployment.yaml
   `

   `
   kubectl apply -f manifests/airflow-service.yaml
   `

- **Access the Airflow Web Interface (forward service-port)**: 

   `
   kubectl port-forward svc/airflow-service 8080:8080
   `

*Open http://localhost:8080 in your browser.*


## Logs from Workers

Logs from Airflow workers are stored in a PersistentVolume and accessible via the Airflow web interface under the "Logs" section.

## Deploying New DAGs

**Update DAG Files:**  

- Modify or add new DAG files in your local *dags/* directory.

**Sync with PV:**

`
kubectl cp ./dags/ <pod-name>:/opt/airflow/dags
`


**Restart Airflow Scheduler:**

`
kubectl delete pod <scheduler-pod-name>
`

## Method for DAG Deployment: PersistentVolume (PV)

This method is chosen for its simplicity and scalability, allowing for straightforward updates to DAGs without complex version control or CI/CD pipelines.

## Troubleshooting Airflow on Kubernetes

### Common Issues and Solutions

**Pods Not Starting or Crashing:**

- Check the logs of the pod using kubectl logs <pod-name>. Look for error messages or stack traces.
- Use `kubectl describe pod <pod-name>` to view events and identify issues with pod scheduling or container startup.

**Scheduler Not Scheduling Tasks:**

- Verify that the scheduler pod is running and healthy. Check the logs for the scheduler pod for errors.
- Ensure that the `executor` in `airflow.cfg` is correctly configured to use `KubernetesExecutor`.

**Tasks Stuck in Queued State:**

- Check the worker pod logs for issues. Verify that the Celery workers are running and able to communicate with the message broker (e.g., RabbitMQ, Redis).
- Ensure that the `sql_alchemy_conn` and `broker_url` are correctly configured in `airflow.cfg.`

**Webserver Not Accessible:**

- Check the service and ingress configurations. Ensure the service is exposing the correct ports and the ingress rules are correctly set up.
- Verify that the webserver pod is running and healthy.

**PersistentVolume Issues:**

- Check the status of the PersistentVolumeClaims (PVCs) using kubectl get pvc. Ensure the PVCs are bound and the PersistentVolumes (PVs) have sufficient capacity.


### Debugging Techniques

**Use Airflow Debugging Mode:**

- Start Airflow components (scheduler, webserver, worker) with the `--debug` flag to enable detailed debugging logs.

**Attach to Running Pods:**

- Use `kubectl exec -it <pod-name> -- /bin/bash` to attach to a running pod and inspect the container environment.

**Inspect Kubernetes Events:**

- Use `kubectl get events` to view events in the Kubernetes cluster. This can help identify issues with pod scheduling, image pulling, and more.

**Check Resource Limits and Quotas:**

- Ensure that your Airflow pods are not being throttled or evicted due to resource constraints. Adjust resource requests and limits in your deployment manifest as needed.

### Best Practices for Stability and Performance

**Resource Requests and Limits:**

- Properly configure resource requests and limits for your Airflow components (webserver, scheduler, workers) to ensure they have sufficient CPU and memory.

**Horizontal Pod Autoscaling:**

- Implement Horizontal Pod Autoscaling (HPA) for the Airflow workers to scale the number of workers based on workload.

**Enable Remote Logging:**

- Configure Airflow to use remote logging (e.g., S3, GCS, Elasticsearch) to store logs externally, reducing the load on the Airflow webserver and scheduler.

**Use a Dedicated Message Broker and Database:**

- Deploy a dedicated message broker (e.g., RabbitMQ, Redis) and database (e.g., PostgreSQL, MySQL) to improve the reliability and scalability of your Airflow deployment.

**Regularly Backup Airflow Metadata Database:**

- Ensure that the Airflow metadata database is regularly backed up to prevent data loss.

**Keep Airflow and Dependencies Updated:**

- Regularly update Airflow and its dependencies to the latest stable versions to benefit from bug fixes and performance improvements.




