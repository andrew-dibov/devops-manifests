# Kubernetes манифесты

Декларативное описание ресурсов [devops](https://github.com/andrew-dibov/devops) для развертывания [application](https://github.com/andrew-dibov/devops-application) и сервисов предыдущих этапов. Применение манифестов происходит через GitHub Actions автоматически при изменениях или вручную с указанием нужной версии.

## Архитектура

> Проект опирается на [application](https://github.com/andrew-dibov/devops-application)

### Слой 1 : GitOps пайплайн : GitHub Actions

| Workflow | Триггер | Действия |
| :-- | :-- | :-- |
| `apply-manifests` | Push в `main` или через `workflow_dispatch` | Установка `kubectl` -> определение тега -> подстановка переменных окружения -> применение манифестов |

### Слой 2 : Манифесты : Kubernetes

| Файл | Ресурс | Назначение |
| :-- | :-- | :-- |
| `deployment` | Deployment : `application` | 4 реплики приложения, использование Rolling Update, параметризация переменными окружения |
| `service` | Service : `application-svc` | NodePort |
| `serviceMonitor` | ServiceMonitor : `application-monitor` | Сбор метрик приложения по эндпоинту `/metrics` |
| `ingress` | Ingress | Веб-приложение и интерфейсоы Grafana, Prometheus, Alertmanager и Atlantis |

### Слой 3 : Автоматическая конфигурация : Bash

Скрипт создает секрет в кластере и обновляет секреты репозитория :

| Ключ | Значение |
| :-- | :-- |
| `CONFIG` | Содержимое `kubeconfig` |
| `REG_ID` | Идентификатор реестра контейнеров |

### Слой 4 : Интеграция с мониторингом : Kubernetes

ServiceMonitor позволяет Prometheus автоматически обнаруживать и собирать метрики приложений по эндпоинту `/metrics`, реализуя observability без ручной настройки.

## Технологии и навыки

| Категория | Технологии/Инструменты | Навыки |
| :-- | :-- | :-- |
| **GitOps** | GitHub Actions | Автоматическое применение манифестов, параметризация переменными окружения |
| **Kubernetes** | Deployment, Service, Ingress, ServiceMonitor, Secrets | Управление жизненным циклом приложения, реализация Ingress, интеграция с Prometheus |
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
