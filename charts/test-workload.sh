#!/bin/bash

CONFIG_FILE="./cnf-testsuite.yml"
# TESTS_TO_SKIP="increase_decrease_capacity helm_chart_valid require_labels versioned_tag nodeport_not_used hostport_not_used secrets_used immutable_configmap reasonable_startup_time reasonable_image_size single_process_type zombie_handled sig_term_handled service_discovery node_drain liveness readiness pod_delete log_output prometheus_traffic open_metrics privileged_containers privilege_escalation host_network non_root_containers immutable_file_systems hostpath_mounts cpu_limits memory_limits"

SKIP_CONFIGURATION="helm_chart_valid require_labels versioned_tag nodeport_not_used hostport_not_used secrets_used immutable_configmap"
SKIP_MICROSERVICE="reasonable_startup_time reasonable_image_size single_process_type zombie_handled sig_term_handled service_discovery"
SKIP_STATE="node_drain"
SKIP_RESILIENCE="liveness readiness pod_delete"
SKIP_COMPATIBILITY="increase_decrease_capacity rolling_update rolling_downgrade rollback"
SKIP_OBSERVABILITY="log_output prometheus_traffic open_metrics"
SKIP_SECURITY="privileged_containers privilege_escalation host_network non_root_containers immutable_file_systems hostpath_mounts cpu_limits memory_limits"

# --- 自動合併要跳過的測試 ---
# 下方指令會將上面所有 SKIP_ 變數的內容合併成一個最終的清單，請勿修改此行。
TESTS_TO_SKIP="${SKIP_CONFIGURATION} ${SKIP_MICROSERVICE} ${SKIP_STATE} ${SKIP_RESILIENCE} ${SKIP_COMPATIBILITY} ${SKIP_OBSERVABILITY} ${SKIP_SECURITY}"

# --- 要執行的 Workload 測試清單 ---
# 這是從 help 文件整理出來的 workload 測試項目，您可以自行增減
tests_to_run=(
    # Configuration Old
    "helm_chart_valid" "require_labels" "versioned_tag" "nodeport_not_used" "hostport_not_used" "secrets_used" "immutable_configmap"
    # Configuration New
    "helm_chart_published" "default_namespace" "latest_tag" "hardcoded_ip_addresses_in_k8s_runtime_configuration" "deprecated_k8s_features" "alpha_k8s_apis" "operator_installed"
    # Microservice Old
    "reasonable_startup_time" "reasonable_image_size" "single_process_type" "zombie_handled" "sig_term_handled" "service_discovery"
    # Microservice New
    "shared_database" "specialized_init_system"
    # State Old
    "node_drain"
    # State New
    "elastic_volumes" "database_persistence" "no_local_volume_configuration"
    # Resilience Old
    "liveness" "readiness" "pod_delete" "pod_network_duplication"
    # Resilience New
    "pod_network_latency" "pod_network_corruption" "disk_fill" "pod_memory_hog" "pod_io_stress" "pod_dns_error"
    # Compatibility Old
    "rolling_update" "rolling_downgrade" "rollback" "increase_decrease_capacity"
    # Compatibility New
    "rolling_version_change" "cni_compatible"
    # Observability Old
    "log_output" "prometheus_traffic" "open_metrics"
    # Observability New
    "routed_logs" "tracing"
    # Security Old
    "privileged_containers" "privilege_escalation" "host_network" "non_root_containers" "immutable_file_systems" "hostpath_mounts" "cpu_limits" "memory_limits"
    # Security New
    "sysctls" "external_ips" "selinux_options" "container_sock_mounts" "symlink_file_system" "application_credentials" "service_account_mapping" "linux_hardening" "insecure_capabilities" "ingress_egress_blocked" "host_pid_ipc_privileges"
)

# tests_to_run=(
#     # 1. Configuration (配置與部署)
#     "helm_chart_published" "helm_chart_valid" "require_labels" "default_namespace" "latest_tag"
#     "versioned_tag" "nodeport_not_used" "hostport_not_used" "hardcoded_ip_addresses_in_k8s_runtime_configuration"
#     "secrets_used" "immutable_configmap" "deprecated_k8s_features" "alpha_k8s_apis" "operator_installed"

#     # 2. Microservice (微服務特性)
#     "shared_database" "reasonable_startup_time" "reasonable_image_size" "single_process_type"
#     "zombie_handled" "sig_term_handled" "service_discovery" "specialized_init_system"

#     # 3. State (狀態管理)
#     "node_drain" "elastic_volumes" "database_persistence" "no_local_volume_configuration"

#     # 4. Resilience (可靠性與混沌工程)
#     "liveness" "readiness" "pod_network_latency" "pod_network_corruption" "pod_network_duplication"
#     "disk_fill" "pod_delete" "pod_memory_hog" "pod_io_stress" "pod_dns_error"

#     # 5. Compatibility (生命週期與相容性)
#     "rolling_update" "rolling_downgrade" "rolling_version_change" "rollback"
#     "increase_decrease_capacity" "cni_compatible"

#     # 6. Observability (可觀測性)
#     "log_output" "prometheus_traffic" "open_metrics" "routed_logs" "tracing"

#     # 7. Security (安全性)
#     "sysctls" "external_ips" "selinux_options" "container_sock_mounts" "privileged_containers"
#     "privilege_escalation" "symlink_file_system" "application_credentials" "host_network"
#     "service_account_mapping" "linux_hardening" "insecure_capabilities" "cpu_limits"
#     "memory_limits" "ingress_egress_blocked" "host_pid_ipc_privileges" "non_root_containers"
#     "immutable_file_systems" "hostpath_mounts"
# )

# --- 執行迴圈 ---
echo "🚀 開始逐一執行 cnf-testsuite 測試..."

for test_name in "${tests_to_run[@]}"; do
    
    # 檢查此測試是否在要跳過的清單中
    if [[ " ${TESTS_TO_SKIP} " =~ " ${test_name} " ]]; then
        echo "⏭️  跳過測試: ${test_name}"
        continue
    fi

    echo "🎬 正在測試: [${test_name}]"
    
    # 執行測試指令
    cnf-testsuite "${test_name}" cnf-config="${CONFIG_FILE}"
    
    # 檢查上一個指令的返回碼，如果不為 0 (代表有錯誤)，則暫停
    if [ $? -ne 0 ]; then
        echo "❌ 測試 [${test_name}] 失敗，腳本已暫停。請檢查錯誤訊息。"
        # 如果你希望遇到錯誤就直接退出，請取消下面一行的註解
        # exit 1
    fi
    echo "--------------------------------------------------"
done

echo "✅ 所有測試執行完畢！"