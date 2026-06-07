# Манифесты

Проект содержит декларативное описание ресурсов для развертывания [application](https://github.com/andrew-dibov/devops-application) и сервисов из предыдущих этапов. Манифесты применяются автоматически через GitHub Actions при изменениях или вручную с указанием версии образа.

## Архитектура

> Проект опирается на [application](https://github.com/andrew-dibov/devops-application)

### Слой 1 : GitOps пайплайн : GitHub Actions

| Workflow | Триггер | Действия |
| :-- | :-- | :-- |
| `apply-manifests` | Push в `main` или `workflow_dispatch` | Установка `kubectl` -> определение тега -> подстановка переменных окружения -> применение манифестов |

### Слой 2 : Манифесты : Kubernetes

| Файл | Ресурс | Назначение |
| :-- | :-- | :-- |
| `deployment` | Deployment `application` | 4 реплики, RollingUpdate, переменные окружения, обращение к секрету |
| `service` | Service `application-svc` | NodePort, `80 -> 5000`, метка для селектора |
| `ingress` | Ingress | Ingress приложения, ingress Grafana, Prometheus, Alertmanager и Atlantis |
| `serviceMonitor` | ServiceMonitor `application-monitor` | Сбор метрик с `/metrics` |

### Слой 3 : Автоматическая конфигурация : Bash

Скрипт создает секрет в кластере и обновляет секреты репозитория :

| Ключ | Значение |
| :-- | :-- |
| `CONFIG` | Содержимое `kubeconfig` в `base64` |
| `REG_ID` | Идентификатор реестра контейнеров |

### Слой 4 : Интеграция с мониторингом : Kubernetes

ServiceMonitor позволяет Prometheus автоматически обнаружить и собрать метрики приложения с эндпоинта `/metrics`, реализуя observability без ручной настройки.

## Технологии и навыки

| Категория | Технологии/Инструменты | Навыки |
| :-- | :-- | :-- |
| **GitOps** | GitHub Actions, kubectl, envsubst | Применение манифестов, параметризация переменными окружения |
| **Kubernetes** | Deployment, Service, Ingress, ServiceMonitor, Secrets | Управление жизненным циклом, настройка проб, ресурсов и стратегий обновления, настройка ingress для доменов, интеграция с Prometheus |
| **Automation** | Bash, CLI | Автоматическая конфигурация репозитория и создание секрета в кластере |
| **Security** | GitHub Secrets, Kubernetes Secrets | Безопасное хранение и передача данных |
| **Observability** | ServiceMonitor | Сбор метрик приложения через CRD |

## Развертывание

```bash
# скопировать и перейти
git clone git@github.com:andrew-dibov/devops-manifests.git && cd devops-manifests

# запустить скрипт инициализации
sudo chmod +x bash/* && ./bash/init.sh
```
