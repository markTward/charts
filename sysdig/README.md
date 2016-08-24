# Sysdig Helm Chart

## Prerequisites Details
* Kubernetes 1.2

## Source
* https://github.com/draios/sysdig-cloud-scripts/tree/master/agent_deploy/kubernetes

## PetSet Details
* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats
* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations


## Chart Details
This chart will do the following:

* Install sysdig-agent on all nodes using Kubernetes DaemonSet

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `sysdig`:

```bash
$ helm install --name sysdig --set AccessKey="<AccessKey>" sysdig-x.x.x.tgz
```

## Configuration

The following tables lists the configurable parameters of the sysdig chart and their default values.

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Name`         | Sysdig DaemonSet name                | `sysdig-agent`                                           |
| `Image`        | Container image name             | `sysdig/agent`                         |
| `ImageTag`     | Container image tag              | `latest`                                               |
| `ImagePullPolicy`     | Container pull policy     | `Always`                                               |
| `Component`    | k8s selector key                 | `sysdig-agent`                                           |
| `AccessKey`          | sysdig-agent access key          | Required ``                                                   |
| `AgentTags`    | sysdig-agent access tags                 | Optional ``                                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name sysdig -f values.yaml sysdig-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)
