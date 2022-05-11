create table brief_category{
	id int unsigned not null auto_increment comment '标识',
	category_name,
	parent_category_id,
	`note`,
}

-- 在管对象的大分类，这些对象包括：简报模板，简报文档，数据集等等
-- 注意这里只记录对应功能模块的模型大分类
-- 该表无需维护代码，少量的数据由开发人员根据业务的实际情况填写
create table subject_explorer{
	id int unsigned not null auto_increment comment '标识',
	hierarchy_subject_type smallint(1) unsigned not null comment '对象管理器需要管理很多不同种类的业务对象，每种业务对象都从不同的表中获取数据',
	hierarchy_subject_id int unsigned not null comment '每种业务对象对应的顶层 managed_subject 的id。没有业务对象这种顶层对象只有一个且不会出现在用户视图上',
	description varchar(255) null comment '对该管理层级的说明',
	access_controll varchar(128) null comment '访问控制所需要的信息，信息保存为字符串，解读和执行由具体的控制逻辑完成'

}


-- 依据数据的 type ，采用的不同的adapt将特定形态的数据输送给前端用于呈现
-- 这里可能会用到命令模式和适配器模式
-- 各种不同类型的业务对象的顶层对象需要预先在表中设置
create table managed_subject{
	id int unsigned not null auto_increment comment '标识',
	naming varchar(255) not null comment '显示在对象管理器上的“文件名”',
	subject_type smallint(1) not null comment '对象的类型，例如：简报模板、数据源。不同类型的对象的 association_id 关联到不同表的id',
	association_id int unsigned not null comment '所关联的业务对象的标识符，依据subject_type的不同，所关联的表也不同',
	is_folder smallint(1) unsigned not null default 0 comment 'folder(目录)是特殊的对象，folder无视 subject_type，仅作为其它非folder对象的parent存在',
	parent_id int unsigned not null comment '指向所属folder的id。最顶层的folder的parent_id为 0 这个特殊值，表示“不存在”的意思',
	access_control varchar(128) null comment '访问控制所需要的信息，信息保存为字符串，解读和执行由具体的控制逻辑完成',
	visible,
	enable,
	notes,
	attribute int unsigned not null comment '对应的对象属性，关联到 managed_subject_attribute 表。不同类型的对象所对应的属性也有所不同', create_time,
	create_user,
}

create table managed_subject_attribute{
	id int unsigned not null auto_increment comment '标识',
}


create table brief_template{
	id int unsigned not null auto_increment comment '标识',
	template_name varchar(255) not null comment '每个模板的名称',
	address varchar(255) not null comment 'word原始文件的存放位置.例如:路径之于磁盘,桶之于对象存储云云',
	template_content mediumtext not null comment '模板的实际内容.由模板处理框架(比如docx4j)解析出来的模板源文本',
	create_time datetime not null default current_timestamp comment '模板创建时间'，
	creator varchar(32) not null comment '创建人的标识，可以是账号或id',
	auditor,
	reminder_id,
	schedule_id,
	primary key (id)
} engine=MyISAM default charset=utf8mb4 comment='简报模板'


create table brief_document{
	id int unsigned not null auto_increment comment '标识',
	brief_template_id int unsigned not null comment '简报的母版',
	produce_time,
	cron int unsigned  comment '生成周期表达式。为空表示是当即生成或手动生成的简报类型',
	document_file,
	version comment '大版本，每次定期生成的简报使用同一个大版本号',
	sub_version comment '表明同一个简报文档的第几次修改'
	locked comment '锁定使简报无法再次被修改上传'
	reminder_process_id,
	readers,
	is_audited,
} charset=utf8mb4 comment='每个具体生成的简报文档实例'


create table cron_expression{
    id
    exp varchar(32),

    note,
}

create table reminder_process{
	id int unsigned not null auto_increment comment '标识',
	remind_time_begin,
	remind_time_end,
	remind_times_done,
	remind_times_limit,
	is_finished comment 'y/n,y表示终止提醒'
}


create table reminder{
	id int unsigned not null auto_increment comment '标识',
	remind_text,
	target_email,
	target_sms,
	target_others,
	enabled comment 'y/n,n表示不可用'
}


create table indicator{
	id int unsigned not null auto_increment comment '标识',
	naming,
	code,
	associated_brief_template_id,
	creator,
	create_time
} engine=MyISAM default charset=utf8mb4 comment='指标段，包含多个指标项'


create table indicator_item{
	id int unsigned not null auto_increment comment '标识',
	code,
	naming,
	associated_indicator_id,
	item_type smallint(1) unsigned not null default 1 comment '简报上的表现形式，目前已知有 1.文本[text] 2.表格[table] 3.图形[chart] 4.后置补充文本[postwrite]',
	concrete_indicator_id int unsigned not null comment '依据 indicator_type 的不同, 分别对应不同的 xxxxx_indicator_item 表中的 id'
	creator,
	create_time
}


create table value_indicator_item{
	id int unsigned not null auto_increment comment '标识',
	indicator_id int unsigned not null comment '指标项从属于哪个指标，对应 indicator.id啊',
	expression varchar(255) not null comment '可以对从数据集中取出的数据进行简单的四则和数学函数计算。引用数据集的数据需要遵从一套简单的描述语法，类似于{dataSetName:dataSetField_index:row_index}',
	value_formatter_id int unsigned comment '每个指标项的格式设定'
}


create table value_indicator_item_formatter{
	id int unsigned not null auto_increment comment '标识',
	color,
	bold,
	italic,
	underline,
	font_size,
	font_family
}


create table table_indicator_item{
	id int unsigned not null auto_increment comment '标识',
	data_set_id unsigned not null comment '数据对接到的 data_set 的id'
	f1_expression varchar(255) not null comment '可以对从数据集中取出的数据进行简单的四则和数学函数计算。引用数据集的数据需要遵从一套简单的描述语法，类似于{dataSetName:dataSetField_index}',
	f1_cell_style_id int unsigned comment 'f1 列的单元格样式。关联到 table_indicator_item_cell_style.id'
	f2_expression
	f2_cell_style_id
	fn_expression
	fn_cell_style_id
}


create table table_indicator_item_cell_style{
	id int unsigned not null auto_increment comment '标识',
	border_style,
	background_color,
	color,
	bold,
	italic,
	underline,
	font_size,
	font_family
}


create table chart_indicator_item{
	id int unsigned not null auto_increment comment '标识',
	chart_type smallint(1) not null comment '指标项为何种图形：1.饼图 2.柱状图 3.折线图 等等'
	global_appearance_id,
	serial1_expression varchar(255) not null comment '可以对从数据集中取出的数据进行简单的四则和数学函数计算。引用数据集的数据需要遵从一套简单的描述语法，类似于"{数据集id:{字段id或计算表达式}:[条件表达式]"',
	serial1_appearance_id,
	serial2_expression
	serial2_appearance_id
	serialn_expression
	serialn_appearance_id
} engine=MyISAM default charset=utf8mb4 comment='表示图形指标项'


create table chart_indicator_item_appearance{
	id int unsigned not null auto_increment comment '标识',
	-- 摘取echart图形最常用的外观属性作为字段。所有类型的图形属性都记录这个外观属性表中，对当前不适用的外观属性置空
} engine=MyISAM default charset=utf8mb4 comment='图形指标项的外观属性'


-- create table variable_map{
-- 	id int unsigned not null auto_increment comment '标识',
-- 	brief_id int unsigned not null comment '应用此关联关系的简报数据的id'，
-- 	variable_code varchar(64) not null comment '模板中可变量的名称',
-- 	variable_indicator_id int unsigned comment '模板中可变量的填充数据目标',
--
-- 	primary key (id)
-- } engine=MyISAM default charset=utf8mb4 comment='模板中可变量和实际数据的映射'


create table indicator_data_source_view_category{
	id int unsigned not null auto_increment comment '标识',
	category_name,
	parent_category_id,
	`note`,
}


create table indicator_data_source_view{
	id int unsigned not null auto_increment comment '标识',
	naming varchar(255) not null comment '显示名，便于用户辨识选择',
	code,
	view_name varchar(128) not null comment '视图的名称',
	view_type smallint(1) not null comment '1.统计型视图 2.明细型视图'
	`build_sql` varchar(4096) not null comment '建立视图的语句'
	`note`,
	tags[reserve],
}


create table indicator_data_set_building{
	id int unsigned not null auto_increment comment '标识',
}


create table indicator_data_set_building_extra_dimension_field{
}


create table indicator_data_set_field{
	id int unsigned not null auto_increment comment '标识',
}


-- 初步的猜测是一个 indicator_struct 会对应多个 data_pipeline，同时一个 data_pipeline 也有可能被多个 indicator_struct 复用,因此设计中间表对应
-- 一个指标可能会对应多个数据来源，因此需要一个“集散地”
create table indicator_hub{
	id int unsigned not null auto_increment comment '标识',
	indicator_id,
	item_id comment '对应哪个表的id取决于 item_type 的值： xxxxx_indicator_item',
	item_type varchar(16) not null comment 'expression/repeater/aggregation 从结果而言，expression输出单一结果，后两者输出数据集',
}


create table data_view_meta{
	id int unsigned not null auto_increment comment '标识',
	view_name
	view_description
	field__name
	field__type
	field__size
	field__note
}



-- 每个source需要在库中有一条作为样例的保留记录
create table data_source_table{
	id int unsigned not null auto_increment comment '标识',
	naming
	source_info varchar(255) not null comment '要设计一个规范的描述格式，说明数据是从哪个数据库哪个表导入的',
	table_name
	field_count
	entry_count
	import_time

}


create table data_source_field_meta{
	id int unsigned not null auto_increment comment '标识',
	source_table int unsigned not null comment '关联到 data_source_table',
	field_name,
	field_type,
	field_size,
	field_order,
	is_indexed,
}


-- 从数据源导入的数据表的命名规范
create table ds_xxxx_xxx{
}

-- data_pipeline 输出自定义的标准化交换格式数据
-- 结构化的数据范例
-- [{
-- 		"foo": 12,
-- 		"bar": "爱",
-- 		"baz": "saiai"
-- 	},
-- 	{
-- 		"foo": 132,
-- 		"bar": "make it",
-- 		"baz": "saiai"
-- 	},
-- 	{
-- 		"foo": 51,
-- 		"bar": "懂王",
-- 		"baz": "Joseph"
-- 	}
-- ]
create table data_pipeline{
	id int unsigned not null auto_increment comment '标识',
	code varchar(48) not null comment '用在指标表达式中的占位符'
	data_adaptor
	data_view_id comment '告知data_adaptor应到哪里拿数据'
	data_feature,
	data_type smallint(1) not null comment '呈现给指标使用的数据类型: 1.数值 2.结构化数据 3.文本 '
	primary key (id)
}


create table data_adaptor{
	id int unsigned not null auto_increment comment '标识',
	naming
	adaptor_class
}


--可以理解为对 data source 的限定条件（时空）
create table data_feature{
	id int unsigned not null auto_increment comment '标识',
}


-- 存档由data_adaptor处输出的自定义的标准格式数据
create table data_archived{
	id int unsigned not null auto_increment comment '标识',
}


create table schedule{
	id int unsigned not null auto_increment comment '标识',
}
