CREATE TABLE steps (
                       id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                       parent_id INT DEFAULT 0 NOT NULL COMMENT '父级id，一般父级都是条件步骤',
                       case_id INT NOT NULL COMMENT '所属测试用例id',
                       content LONGTEXT NOT NULL COMMENT '输入文本',
                       error INT NOT NULL COMMENT '异常处理类型',
                       platform INT NOT NULL COMMENT '设备系统类型',
                       project_id INT NOT NULL COMMENT '所属项目id',
                       sort INT NOT NULL COMMENT '排序号',
                       step_type VARCHAR(255) NOT NULL COMMENT '步骤类型',
                       text LONGTEXT NOT NULL COMMENT '其它信息',
                       condition_type INT DEFAULT 0 NOT NULL COMMENT '条件类型',
                       disabled INT DEFAULT 0 NOT NULL COMMENT '是否禁用',
                       PRIMARY KEY (id),
                       INDEX IDX_CASE_ID (case_id),
                       INDEX IDX_PROJECT_ID (project_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='测试步骤表';

CREATE TABLE agents (
                        id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                        host VARCHAR(255) NOT NULL COMMENT 'agent的ip',
                        name VARCHAR(255) NOT NULL COMMENT 'agent name',
                        port INT NOT NULL COMMENT 'agent的端口',
                        secret_key VARCHAR(255) DEFAULT '' COMMENT 'agent的密钥',
                        status INT NOT NULL COMMENT 'agent的状态',
                        system_type VARCHAR(255) NOT NULL COMMENT 'agent的系统类型',
                        version VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'agent端代码版本',
                        lock_version BIGINT NOT NULL DEFAULT 0 COMMENT '乐观锁，优先保证上下线状态落库',
                        high_temp INT NOT NULL DEFAULT 45 COMMENT 'highTemp',
                        high_temp_time INT NOT NULL DEFAULT 15 COMMENT 'highTempTime',
                        robot_secret VARCHAR(255) NOT NULL DEFAULT '' COMMENT '机器人秘钥',
                        robot_token VARCHAR(255) NOT NULL DEFAULT '' COMMENT '机器人token',
                        robot_type INT NOT NULL DEFAULT 1 COMMENT '机器人类型',
                        has_hub INT NOT NULL DEFAULT 0 COMMENT '是否使用了Sonic hub',
                        alert_robot_ids VARCHAR(1024) COMMENT '逗号分隔通知机器人id串，为null时自动选取所有可用机器人'
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='agents表';


CREATE TABLE alert_robots (
                              id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                              project_id INT DEFAULT NULL COMMENT '可用项目id，null为公共机器人',
                              name VARCHAR(255) NOT NULL COMMENT '显示名称',
                              robot_secret VARCHAR(255) DEFAULT NULL COMMENT '机器人秘钥',
                              robot_token VARCHAR(255) NOT NULL COMMENT '机器人token/接口uri',
                              robot_type INT NOT NULL COMMENT '机器人类型',
                              scene VARCHAR(255) NOT NULL COMMENT '使用场景，可选 agent, testsuite, summary',
                              mute_rule VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '静默规则，SpEL表达式，表达式求值为true时不发送消息，否则正常发送',
                              template VARCHAR(4096) NOT NULL DEFAULT '' COMMENT '通知模板，SpEL表达式，表达式为空时机器人类型自动使用默认值',
                              INDEX IDX_PROJECT_ID (project_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='alert_robots表';

CREATE TABLE conf_list (
                           id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                           conf_key VARCHAR(255) NOT NULL COMMENT '业务key',
                           content VARCHAR(255) NOT NULL COMMENT '内容',
                           extra VARCHAR(255) DEFAULT NULL COMMENT '扩展信息',
                           create_time DATETIME NOT NULL COMMENT '创建时间',
                           update_time DATETIME DEFAULT NULL COMMENT '更新时间',
                           INDEX IDX_CONF_KEY (conf_key)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='配置信息表';

CREATE TABLE devices (
                         id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                         agent_id INT NOT NULL COMMENT '所属agent的id',
                         cpu VARCHAR(255) DEFAULT '' COMMENT 'cpu架构',
                         img_url VARCHAR(255) DEFAULT '' COMMENT '手机封面',
                         manufacturer VARCHAR(255) DEFAULT '' COMMENT '制造商',
                         model VARCHAR(255) DEFAULT '' COMMENT '手机型号',
                         name VARCHAR(255) DEFAULT '' COMMENT '设备名称',
                         password VARCHAR(255) DEFAULT '' COMMENT '设备安装app的密码',
                         platform INT NOT NULL COMMENT '系统类型 1：android 2：ios',
                         is_hm INT NOT NULL DEFAULT 0 COMMENT '是否为鸿蒙类型 1：鸿蒙 0：非鸿蒙',
                         size VARCHAR(255) DEFAULT '' COMMENT '设备分辨率',
                         status VARCHAR(255) DEFAULT '' COMMENT '设备状态',
                         ud_id VARCHAR(255) DEFAULT '' COMMENT '设备序列号',
                         version VARCHAR(255) DEFAULT '' COMMENT '设备系统版本',
                         nick_name VARCHAR(255) DEFAULT '' COMMENT '设备备注',
                         user VARCHAR(255) DEFAULT '' COMMENT '设备当前占用者',
                         chi_name VARCHAR(255) DEFAULT '' COMMENT '中文设备',
                         temperature INT DEFAULT 0 COMMENT '设备温度',
                         voltage INT DEFAULT 0 COMMENT '设备电池电压',
                         level INT DEFAULT 0 COMMENT '设备电量',
                         position INT DEFAULT 0 COMMENT 'HUB位置',
                         INDEX IDX_UD_ID (ud_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='设备表';

CREATE TABLE elements (
                          id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                          ele_name VARCHAR(255) NOT NULL COMMENT '控件名称',
                          ele_type VARCHAR(255) NOT NULL COMMENT '控件类型',
                          ele_value LONGTEXT COMMENT '控件内容',
                          project_id INT NOT NULL COMMENT '所属项目id',
                          module_id INT DEFAULT 0 COMMENT '所属项目模块id',
                          INDEX IDX_PROJECT_ID (project_id),
                          INDEX IDX_MODULE_ID (module_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='控件元素表';

CREATE TABLE global_params (
                               id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                               params_key VARCHAR(255) NOT NULL COMMENT '参数key',
                               params_value VARCHAR(255) NOT NULL COMMENT '参数value',
                               project_id INT NOT NULL COMMENT '所属项目id',
                               INDEX IDX_PROJECT_ID (project_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='全局参数表';

CREATE TABLE jobs (
                      id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                      cron_expression VARCHAR(255) NOT NULL COMMENT 'cron表达式',
                      name VARCHAR(255) NOT NULL COMMENT '任务名称',
                      project_id INT NOT NULL COMMENT '所属项目id',
                      status INT NOT NULL COMMENT '任务状态 1：开启 2：关闭',
                      suite_id INT NOT NULL COMMENT '测试套件id',
                      type VARCHAR(255) NOT NULL DEFAULT 'testJob' COMMENT '定时任务类型',
                      INDEX IDX_PROJECT_ID (project_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='定时任务表';

CREATE TABLE modules (
                         id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                         name VARCHAR(255) COMMENT '模块名称',
                         project_id INT NOT NULL COMMENT '所属项目ID',
                         INDEX IDX_PROJECT_ID (project_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='模块表';

CREATE TABLE packages (
                          id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                          project_id INT NOT NULL COMMENT '项目描述',
                          pkg_name VARCHAR(255) NOT NULL COMMENT '安装包名称',
                          platform VARCHAR(255) NOT NULL COMMENT '平台',
                          branch VARCHAR(255) NOT NULL COMMENT '构建分支',
                          url VARCHAR(255) NOT NULL COMMENT '下载地址',
                          build_url VARCHAR(255) NOT NULL COMMENT '来源地址',
                          create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '任务创建时间',
                          update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='安装包表';

CREATE TABLE projects (
                          id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                          edit_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更改时间',
                          project_des VARCHAR(255) NOT NULL COMMENT '项目描述',
                          project_img VARCHAR(255) NOT NULL COMMENT '项目封面',
                          project_name VARCHAR(255) NOT NULL COMMENT '项目名',
                          robot_secret VARCHAR(255) COMMENT '机器人秘钥',
                          robot_token VARCHAR(255) NOT NULL COMMENT '机器人token',
                          robot_type INT NOT NULL COMMENT '机器人类型',
                          testsuite_alert_robot_ids VARCHAR(1024) COMMENT '项目内测试套件默认通知机器人，逗号分隔id串，为null时自动选取所有可用机器人',
                          global_robot TINYINT(1) NOT NULL DEFAULT 1 COMMENT '启用全局机器人',
                          UNIQUE KEY idx_unique_project_name (project_name)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='项目表';

CREATE TABLE public_steps (
                              id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
                              name VARCHAR(255) NOT NULL COMMENT '公共步骤名称',
                              platform INT NOT NULL COMMENT '公共步骤系统类型（android、ios...）',
                              project_id INT NOT NULL COMMENT '所属项目id',
                              INDEX IDX_PROJECT_ID (project_id),
                              UNIQUE KEY idx_unique_name_project (name, project_id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='公共步骤表';

CREATE TABLE public_steps_steps (
                                    public_steps_id INT NOT NULL COMMENT '公共步骤id',
                                    steps_id INT NOT NULL COMMENT '步骤id',
                                    PRIMARY KEY (public_steps_id, steps_id),
                                    FOREIGN KEY (public_steps_id) REFERENCES public_steps(id),
                                    FOREIGN KEY (steps_id) REFERENCES steps(id)
)
    ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='公共步骤 - 步骤 关系映射表';

CREATE TABLE resources (
                           id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                           `desc` VARCHAR(255) NOT NULL COMMENT '描述',
                           parent_id INT NOT NULL DEFAULT 0 COMMENT '父级 ID',
                           method VARCHAR(20) NOT NULL COMMENT '请求方法',
                           path VARCHAR(255) NOT NULL COMMENT '资源路径',
                           white INT NOT NULL DEFAULT 1 COMMENT '是否是白名单 URL，0是 1不是',
                           version VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'URL 资源的版本',
                           need_auth INT NOT NULL DEFAULT 1 COMMENT '是否需要鉴权，0 不需要 1 需要',
                           create_time DATETIME NOT NULL COMMENT '创建时间',
                           update_time DATETIME COMMENT '更新时间',
                           PRIMARY KEY (id),
                           INDEX idx_method (method),
                           INDEX idx_path (path),
                           INDEX idx_version (version)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='资源信息表';

CREATE TABLE result_detail (
                               id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                               case_id INT NOT NULL COMMENT '测试用例ID',
                               `desc` VARCHAR(255) DEFAULT '' COMMENT '描述',
                               device_id INT NOT NULL COMMENT '设备ID',
                               log LONGTEXT COMMENT '日志信息',
                               result_id INT NOT NULL COMMENT '所属结果ID',
                               status INT NOT NULL COMMENT '步骤执行状态',
                               time TIMESTAMP NOT NULL COMMENT '步骤执行状态',
                               type VARCHAR(255) DEFAULT '' COMMENT '测试结果详情类型',
                               PRIMARY KEY (id),
                               INDEX idx_result_id_case_id_type_device_id (result_id, case_id, type, device_id),
                               INDEX idx_time (time),
                               INDEX idx_type (type)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='任务结果详情表';

CREATE TABLE results (
                         id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                         create_time DATETIME NOT NULL COMMENT '任务创建时间',
                         end_time DATETIME COMMENT '任务结束时间',
                         project_id INT NOT NULL COMMENT '所属项目ID',
                         receive_msg_count INT NOT NULL COMMENT '接受消息数量',
                         send_msg_count INT NOT NULL COMMENT '发送消息数量',
                         status INT NOT NULL COMMENT '结果状态',
                         strike VARCHAR(255) DEFAULT '' COMMENT '触发者',
                         suite_id INT NOT NULL COMMENT '测试套件ID',
                         suite_name VARCHAR(255) DEFAULT '' COMMENT '测试套件名字',
                         PRIMARY KEY (id),
                         INDEX idx_project_id (project_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='测试结果表';

CREATE TABLE resource_roles (
                                id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                role_id INT NOT NULL COMMENT '角色ID',
                                res_id INT NOT NULL COMMENT '资源ID',
                                create_time DATETIME NOT NULL COMMENT '创建时间',
                                update_time DATETIME COMMENT '更新时间',
                                PRIMARY KEY (id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='角色资源表';

CREATE TABLE roles (
                       id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                       role_name VARCHAR(255) NOT NULL COMMENT '角色名称',
                       comment VARCHAR(255) NOT NULL COMMENT '描述',
                       create_time DATETIME NOT NULL COMMENT '创建时间',
                       update_time DATETIME COMMENT '更新时间',
                       PRIMARY KEY (id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
AUTO_INCREMENT=100
COMMENT='角色表';

CREATE TABLE scripts (
                         id INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                         project_id INT NOT NULL COMMENT '所属项目id',
                         name VARCHAR(255) NOT NULL COMMENT '名称',
                         script_language VARCHAR(255) NOT NULL COMMENT '脚本语言',
                         content LONGTEXT NOT NULL COMMENT '内容',
                         PRIMARY KEY (id),
                         INDEX IDX_PROJECT_ID (project_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='scripts表';

CREATE TABLE steps_elements (
                                steps_id INT NOT NULL COMMENT '步骤id',
                                elements_id INT NOT NULL COMMENT '控件id',
                                PRIMARY KEY (steps_id, elements_id) -- 使用组合主键确保每个步骤与控件的关系唯一
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='步骤 - 控件 关系映射表';

CREATE TABLE test_cases (
                            id INT NOT NULL AUTO_INCREMENT COMMENT '主键id',
                            des VARCHAR(255) NOT NULL COMMENT '用例描述',
                            designer VARCHAR(255) NOT NULL COMMENT '用例设计人',
                            edit_time DATETIME NOT NULL COMMENT '最后修改日期',
                            module_id INT DEFAULT 0 COMMENT '所属模块',
                            name VARCHAR(255) NOT NULL COMMENT '用例名称',
                            platform INT NOT NULL COMMENT '设备系统类型',
                            project_id INT NOT NULL COMMENT '所属项目id',
                            version VARCHAR(50) NOT NULL COMMENT '版本号',
                            PRIMARY KEY (id),
                            KEY IDX_MODULE_ID (module_id),
                            KEY IDX_PROJECT_ID (project_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='测试用例表';

CREATE TABLE test_suites (
                             id INT NOT NULL AUTO_INCREMENT COMMENT '主键id',
                             cover INT NOT NULL COMMENT '覆盖类型',
                             name VARCHAR(255) NOT NULL COMMENT '测试套件名字',
                             platform INT NOT NULL COMMENT '测试套件系统类型（android、ios...）',
                             is_open_perfmon INT NOT NULL DEFAULT 0 COMMENT '是否采集系统性能数据',
                             perfmon_interval INT NOT NULL DEFAULT 1000 COMMENT '采集性能数据间隔',
                             project_id INT NOT NULL COMMENT '项目id',
                             alert_robot_ids VARCHAR(1024) COMMENT '项目内测试套件默认通知配置，为null时取项目配置的默认值',
                             PRIMARY KEY (id),
                             KEY IDX_PROJECT_ID (project_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='测试套件表';

CREATE TABLE test_suites_devices (
                                     test_suites_id INT NOT NULL COMMENT '测试套件id',
                                     devices_id INT NOT NULL COMMENT '设备id',
                                     sort INT NOT NULL DEFAULT 0 COMMENT '排序用',
                                     PRIMARY KEY (test_suites_id, devices_id),
                                     KEY idx_test_suites_id_devices_id (test_suites_id, devices_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='测试套件 - 设备 关系映射表';

CREATE TABLE test_suites_test_cases (
                                        test_suites_id INT NOT NULL COMMENT '测试套件id',
                                        test_cases_id INT NOT NULL COMMENT '测试用例id',
                                        sort INT NOT NULL DEFAULT 0 COMMENT '排序用',
                                        PRIMARY KEY (test_suites_id, test_cases_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='测试套件 - 测试用例 关系映射表';

CREATE TABLE users (
                       id INT NOT NULL AUTO_INCREMENT COMMENT '用户表主键',
                       password VARCHAR(255) NOT NULL COMMENT '密码',
                       userRole INT COMMENT '角色',
                       user_name VARCHAR(255) NOT NULL COMMENT '用户名',
                       source VARCHAR(255) NOT NULL DEFAULT 'LOCAL' COMMENT '用户来源',
                       PRIMARY KEY (id),
                       UNIQUE KEY UNI_USER_NAME (user_name)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='用户表';

CREATE TABLE versions (
                          id INT NOT NULL AUTO_INCREMENT COMMENT '版本表主键',
                          create_time DATETIME NOT NULL COMMENT '创建时间',
                          project_id INT NOT NULL COMMENT '所属项目id',
                          version_name VARCHAR(255) NOT NULL COMMENT '迭代名称',
                          PRIMARY KEY (id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='版本表';