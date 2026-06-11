# Manifests

Декларативное описание ресурсов для развертывания [application](https://github.com/andrew-dibov/devops-application) и сервисов предыдущих этапов. Применение манифестов через GitHub Actions при изменении или вручную.

## Архитектура

> Манифесты подразумевают готовность [bootstrap](https://github.com/andrew-dibov/devops-bootstrap), [network](https://github.com/andrew-dibov/devops-network), [kubernetes](https://github.com/andrew-dibov/devops-kubernetes) и [application](https://github.com/andrew-dibov/devops-application)

### Слой 1 : Манифесты : Kubernetes

| Манифест | Ресурс | Назначение |
| :-- | :-- | :-- |
| `deployment` | Deployment `application` | 4 реплики приложения с Rolling Update |
| `service` | Service `application-svc` | NodePort |
| `serviceMonitor` | ServiceMonitor `application-monitor` | Метрики приложения по `/metrics` |
| `ingress` | Ingress | Веб-приложение и интерфейсы Grafana, Prometheus и Atlantis |

### Слой 2 : GitOps : GitHub Actions

| Пайплайн | Триггер | Действия |
| :-- | :-- | :-- |
| `apply-manifests` | Push в ветку `main` или выполнение `workflow_dispatch` | Установка и настройка `kubectl` -> определение тега -> подстановка переменных окружения -> применение манифестов |

### Слой 3 : Конфигурация репозитория : Bash

Скрипт создает секрет в кластере и обновляет секреты репозитория :

| Ключ | Значение |
| :-- | :-- |
| `CONFIG` | Содержимое `kubeconfig` |
| `REG_ID` | Идентификатор реестра контейнеров |

### Слой 4 : Observability : Kubernetes

ServiceMonitor позволяет Prometheus автоматически обнаруживать и собирать метрики приложения по эндпоинту `/metrics` без ручной настройки.

## Технологии и навыки

| Категория | Технологии/Инструменты | Навыки |
| :-- | :-- | :-- |
| **GitOps & CI/CD** | GitHub Actions | Настройка пайплайнов и управление секретами |
| **Orchestration** | Deployment, Service, Ingress, ServiceMonitor, Secrets | Управление жизненным циклом приложения, реализация Ingress, интеграция с Prometheus |
| **Automation** | Bash, CLI | Автоматическая конфигурация репозитория |
| **Security** | GitHub Secrets, Kubernetes Secrets | Безопасное хранение и передача данных |
| **Observability** | ServiceMonitor | Сбор метрик приложения через CRD |

## Развертывание

```bash
# скопировать и перейти
git clone git@github.com:andrew-dibov/devops-manifests.git && cd devops-manifests

# запустить скрипт инициализации
sudo chmod +x bash/* && ./bash/init.sh
```
