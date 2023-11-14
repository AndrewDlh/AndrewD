#!/opt/conda/bin/Rscript
####第一步转格式（人大小鼠）
library(readxl)
library(utils)

# 指定路径
excel_file <- "分析确认单.xlsx"

# 读取工作表
data <- read_excel(excel_file, sheet = "分析基本信息")

# 获取“key”和“value”列的内容
col1 <- data$"key"
col2 <- data$"value"

# 查找“样本物种”的行
sample_species_row <- which(col1 == "样本物种")

# 如果找到了“样本物种”的行
if (length(sample_species_row) > 0) {
  # 获取样本物种的值
  sample_species <- col2[sample_species_row[1]]
  
  # 根据样本物种执行不同的命令
  if (sample_species == "人") {
    system("getprojectinfo -ks hsa")
  } else if (sample_species == "小鼠") {
    system("getprojectinfo -ks mmu")
  } else if (sample_species == "大鼠") {
    system("getprojectinfo -ks rno")
  } else {
    # 不是小鼠大鼠人时
    print("判断不是常见物种，请手动输入物种映射: ")
    user_input <- tolower(trimws(readLines("stdin",n = 1)))
    # 输入物种名，执行相应命令
    if (nchar(user_input) > 0) {
      cmd <- paste("getprojectinfo -ks", user_input)
      system(cmd)
    } else {
      cat("未输入物种名，未执行任何操作。\n")
    }
  }
} else {
  cat("未找到样本物种信息。\n")
}

#转格式完成后进行QC

#指定路径
current_directory = getwd()
excel_file = file.path(current_directory,"内部分析单.xlsx")

#读取数据
data = read_excel(excel_file,sheet = "分析基本信息")

#获取第一列和第二列
col1 = data$"key"
col2 = data$"value"

#判断有无
if(is.null(col1)||length(col1)==0){
	cat("Excel文件中没有数据或数据为空。\n")
}else{
 #执行质控
 for (i in 1:length(col1)){
	 if(col1[i] == "QC质控"){
		 if(col2[i] == "有"){
			 #质控
			 system("metaboanalysis_2023 -t metabo_result_pre")
		 }else if (clo2[i] == "无"){
			 system("metaboanalysis_2023")
		 }
	 }
 }
}

