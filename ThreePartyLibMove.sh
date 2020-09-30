
### 三方库迁移脚本

Version_Code="Version:1.0.0"
RootPath=`pwd`

Handle_CreatStore="创建三方组件远程仓库"
Handle_git_clone="Clone仓库内容到本地"
Handle_AddLICENSE="添加LICENSE"
Handle_OpenLICENSE="打开LICENSE"
Handle_AddREADME_md="添加README.md"
Handle_OpenREADME_md="打开README.md"
Handle_CreatPodspec="创建podspec"
Handle_OpenPodspec="打开podspec"
Handle_PushTALRemote="代码推送到集团远程仓库"
Handle_pod_repo_add="本地repo添加source"
Handle_CreatStoreTag="集团仓库中创建对应的tag"
Handle_pod_repo_push="推送repo版本"

Handle_Exit="0. 退出"
Handle_Back="0. 返回上一级"
XES_TAIL_SEPARATE="========================================="

# 执行操作列表
function getHandleArr()
{
    HandleArr=(
        $Handle_CreatStore
        $Handle_git_clone
        $Handle_AddLICENSE
        $Handle_OpenLICENSE
        $Handle_AddREADME_md
        $Handle_OpenREADME_md
        $Handle_CreatPodspec
        $Handle_OpenPodspec
        $Handle_PushTALRemote
        $Handle_pod_repo_add
        $Handle_CreatStoreTag
        $Handle_pod_repo_push
    )
}

# 打开指定文件夹
function openAppointFile()
{
    # 打印当前目录下的所有文件夹名称
    project_path=$(cd `dirname $0`; pwd)
    for dir in $(ls $project_path)
    do
     [ -d $dir ] && echo $dir
    done
    
    echo $XES_TAIL_SEPARATE
    echo "请输入要操作的文件夹名称:"

    read fileName
    
    if [ "$fileName" = "" ];then
        echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
    
    cd $RootPath/$fileName
}

# 1.创建三方组件仓库
function creatRemoteStoreAction()
{
    echo "请输入要创建的仓库名称:"
    
    read remoteName
    if [ "$remoteName" = "" ];then
        echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
    
    echo "$XES_TAIL_SEPARATE 执行命令... $XES_TAIL_SEPARATE"
    
    # 执行创建命令
    git init
    curl -u 'wuyukobe24' https://api.github.com/user/repos -d '{"name":"wxqRemoteUrl"}'
    git remote add origin https://github.com/wuyukobe24/wxqRemoteUrl.git
    git add .
    git commit -m "Initial commit"
    git push origin master
    
    echo "$XES_TAIL_SEPARATE 命令执行完成 $XES_TAIL_SEPARATE"
}

# 2.Clone仓库内容到本地
function gitCloneAction()
{
    echo "请输入要clone的远程url:"

    read remoteUrl
    if [ "$remoteUrl" = "" ];then
        echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
    
    echo "$XES_TAIL_SEPARATE clone... $XES_TAIL_SEPARATE"
    
    git clone $remoteUrl
}

# 3.添加LICENSE
function addLICENSEAction()
{
    openAppointFile
    
    touch LICENSE
    
    echo "$XES_TAIL_SEPARATE 添加 LICENSE 完成 $XES_TAIL_SEPARATE"
    
    # 打开LICENSE
    openLICENSEAction
}

# 4.打开LICENSE
function openLICENSEAction()
{
    echo "是否需要打开LICENSE:"
    echo "1. 打开"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    
    if [[ $number -eq 1 ]];then
        # 打开
        vim LICENSE
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
}

# 5.添加README.md
function addReadmeMDAction()
{
    openAppointFile
    
    touch README.md
    
    echo "$XES_TAIL_SEPARATE 成功添加README.md $XES_TAIL_SEPARATE"
    echo "是否需要打开README.md:"
    echo "1. 打开"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    
    if [[ $number -eq 1 ]];then
        # 打开
        vim README.md
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
}

# 6.打开README.md
function openReadmeMDAction()
{
    openAppointFile
    
    vim README.md
}

# 7.创建podspec
function creatPodspecAction()
{
    openAppointFile
    
    # 当前文件夹路径
    project_path=$(cd `dirname $0`; pwd)
    # 当前文件夹名称
    project_name="${project_path##*/}"
    
    echo "$XES_TAIL_SEPARATE"
    echo "您是否要创建 $project_name.podspec :"
    echo "1. YES"
    echo "2. 创建其他名称"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    if [[ $number -eq 1 ]];then
        
        # 创建podspec
        creatPodspec $project_name
        
    elif [[ $number -eq 2 ]]; then
        # 创建其他名称
        echo "$XES_TAIL_SEPARATE"
        echo "请输入需要创建的名称:"
        
        read fileName
        
        if [ "$fileName" = "" ];then
            echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
            return
        else
            echo "$XES_TAIL_SEPARATE"
            echo "您是否确定创建$fileName.podspec :"
            echo "1. YES"
            echo $Handle_Back
            echo "$XES_TAIL_SEPARATE"
            echo "请输入你的选择:"
            
            read number
            if [[ $number -eq 1 ]];then
                
                # 创建podspec
                creatPodspec $fileName
                
            else
                # 返回上一级
                echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
                return
            fi
                
        fi
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
    
}

# 创建podspec
function creatPodspec()
{
    project_name=$1
    echo "$XES_TAIL_SEPARATE  创建中... $XES_TAIL_SEPARATE"
    
    # 确定创建
    pod spec create $project_name
    
    echo "$XES_TAIL_SEPARATE  成功创建$project_name.podspec $XES_TAIL_SEPARATE"
    
    # 打开podspec
    openPodspec $project_name
}

# 8.打开podspec
function openPodspecAction()
{
    openAppointFile
    
    # 当前文件夹路径
    project_path=$(cd `dirname $0`; pwd)
    # 当前文件夹名称
    project_name="${project_path##*/}"
    
    echo "$XES_TAIL_SEPARATE"
    
    # 打开podspec
    openPodspec $project_name
}

# 打开podspec
function openPodspec()
{
    project_name=$1
    
    echo "您是否要打开 $project_name.podspec :"
    echo "1. YES"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    if [[ $number -eq 1 ]];then
        # 打开
        specName="$project_name.podspec"
        vim $specName
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
}

# 9.推送到集团远程仓库
function pushTALRemoteAction()
{
    openAppointFile
    
    # 当前文件夹路径
    project_path=$(cd `dirname $0`; pwd)
    # 当前文件夹名称
    project_name="${project_path##*/}"
    
    echo "$XES_TAIL_SEPARATE"
    echo "您是否要将 $project_name 下代码推送到集团远程仓库 :"
    echo "1. YES"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    if [[ $number -eq 1 ]];then

        # 请输入远程仓库URL
        echo "$XES_TAIL_SEPARATE"
        echo "请输入远程仓库URL:"
        
        read remoteUrl
        if [ "$remoteUrl" = "" ];then
            echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
        # 请输入提交信息
        echo "$XES_TAIL_SEPARATE"
        echo "请输入提交信息:"
        
        read commitMsg
        
        echo "$XES_TAIL_SEPARATE 执行命令... $XES_TAIL_SEPARATE"
        
        # 执行命令 wxq
#        git init
#        git remote add origin $remoteUrl
#        git add .
#        git commit -m "$commitMsg"
#        git push -u origin master
         
         echo "git init"
         echo "git remote add origin $remoteUrl"
         echo "git add ."
         echo "git commit -m "$commitMsg""
         echo "git push -u origin master"
        
         echo "$XES_TAIL_SEPARATE 命令执行完成 $XES_TAIL_SEPARATE"
        
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
}

# 10.本地repo添加source
function podRepoAddAction()
{
    echo "请选择操作的repo名称:"
    echo "1. 三方库迁移repo（默认）"
    echo "2. 选择其他repo"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    if [[ $number -eq 1 ]]; then
    
        echo "$XES_TAIL_SEPARATE"
        echo "默认执行命令: pod repo add tal_internal_pods https://git.100tal.com/tal_internal_pods/talinternalpodrepo :"
        echo "1. YES"
        echo $Handle_Back
        echo "$XES_TAIL_SEPARATE"
        echo "请输入你的选择:"
        
        read number
        if [[ $number -eq 1 ]];then
            # 执行命令 wxq
#            pod repo add tal_internal_pods https://git.100tal.com/tal_internal_pods/talinternalpodrepo
            echo "pod repo add tal_internal_pods https://git.100tal.com/tal_internal_pods/talinternalpodrepo"
            echo "$XES_TAIL_SEPARATE 命令执行完成 $XES_TAIL_SEPARATE"
        else
            # 返回上一级
            echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
    
    elif [[ $number -eq 2 ]]; then
        
        # 输入repo名称，比如：tal_internal_pods
        echo "$XES_TAIL_SEPARATE"
        echo "请输入执行的repo名称:"
        
        read repoName
        if [ "$repoName" = "" ];then
            echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
        # 输入repo仓库url，比如：https://git.100tal.com/tal_internal_pods/talinternalpodrepo
        echo "$XES_TAIL_SEPARATE"
        echo "请输入执行的repo仓库url:"
        
        read repoRemoteUrl
        if [ "$repoRemoteUrl" = "" ];then
            echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
        # 执行命令
        echo "$XES_TAIL_SEPARATE"
        echo "是否执行命令: pod repo add $repoName $repoRemoteUrl :"
        echo "1. YES"
        echo $Handle_Back
        echo "$XES_TAIL_SEPARATE"
        echo "请输入你的选择:"
        
        read number
        if [[ $number -eq 1 ]];then
            # 执行命令 wxq
#            pod repo add $repoName $repoRemoteUrl
            echo "pod repo add $repoName $repoRemoteUrl"
            echo "$XES_TAIL_SEPARATE 命令执行完成 $XES_TAIL_SEPARATE"
        else
            # 返回上一级
            echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
}

# 12.推送repo版本
function podRepoPushAction()
{
    echo "请选择操作的repo名称:"
    echo "1. 三方库迁移repo（默认）"
    echo "2. 选择其他repo"
    echo $Handle_Back
    echo "$XES_TAIL_SEPARATE"
    echo "请输入你的选择:"
    
    read number
    if [[ $number -eq 1 ]]; then
    
        echo "$XES_TAIL_SEPARATE"
        
        openAppointFile
        
        # 当前文件夹路径
        project_path=$(cd `dirname $0`; pwd)
        # 当前文件夹名称
        project_name="${project_path##*/}"
        
        echo "$XES_TAIL_SEPARATE"
        echo "您当前选择的文件名是:$project_name, 是否执行以下推送repo版本命令(默认): pod repo push tal_internal_pods $project_name.podspec --verbose --use-libraries --allow-warnings --skip-import-validation --skip-tests"
        echo "1. YES"
        echo $Handle_Back
        echo "$XES_TAIL_SEPARATE"
        echo "请输入你的选择:"
        
        read number
        if [[ $number -eq 1 ]];then
            # 执行命令 wxq
#            specName="$project_name.podspec"
#            pod repo push tal_internal_pods specName --verbose --use-libraries --allow-warnings --skip-import-validation --skip-tests
            echo "pod repo push tal_internal_pods $project_name.podspec --verbose --use-libraries --allow-warnings --skip-import-validation --skip-tests"
            echo "$XES_TAIL_SEPARATE 命令执行完成 $XES_TAIL_SEPARATE"
        else
            # 返回上一级
            echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
    elif [[ $number -eq 2 ]]; then
    
        # 输入repo名称，比如：tal_internal_pods
        echo "$XES_TAIL_SEPARATE"
        echo "请输入执行的repo名称:"
        
        read repoName
        if [ "$repoName" = "" ];then
            echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
        # 输入spec名称，比如：YYKit
        echo "$XES_TAIL_SEPARATE"
        echo "请输入执行的spec名称:（比如: YYKit）"
        
        read specName
        if [ "$specName" = "" ];then
            echo "$XES_TAIL_SEPARATE  返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
        # 执行命令
        echo "$XES_TAIL_SEPARATE"
        echo "是否执行命令:pod repo push $repoName $specName.podspec --verbose --use-libraries --allow-warnings --skip-import-validation --skip-tests :"
        echo "1. YES"
        echo $Handle_Back
        echo "$XES_TAIL_SEPARATE"
        echo "请输入你的选择:"
        
        read number
        if [[ $number -eq 1 ]];then
            # 执行命令 wxq
#            specFullName="$specName.podspec"
#            pod repo push $repoName $specFullName --verbose --use-libraries --allow-warnings --skip-import-validation --skip-tests
            echo "pod repo push $repoName $specName.podspec --verbose --use-libraries --allow-warnings --skip-import-validation --skip-tests"
            echo "$XES_TAIL_SEPARATE 命令执行完成 $XES_TAIL_SEPARATE"
        else
            # 返回上一级
            echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
            return
        fi
        
    else
        # 返回上一级
        echo "$XES_TAIL_SEPARATE 返回上一级 $XES_TAIL_SEPARATE"
        return
    fi
}

function homeHandle()
{
    getHandleArr
    
    echo $XES_TAIL_SEPARATE
    
    handleCount=${#HandleArr[@]}
    for((i=1;i<=$handleCount;i++));
    do
        echo $i. ${HandleArr[$i -1 ]}
    done
    
    echo $Handle_Exit
    echo $Version_Code
    
    echo $XES_TAIL_SEPARATE
    echo "请输入你的选项："
    
    read number
    echo $XES_TAIL_SEPARATE
    
    if [[ $number -eq 0 ]];then
        # 执行0 退出脚本
        echo "$XES_TAIL_SEPARATE 退出脚本 $XES_TAIL_SEPARATE"
        exit
        
    elif  (( "$number" <= "$handleCount" ));then
        handle=${HandleArr[$number - 1]}
        echo "$XES_TAIL_SEPARATE  执行$handle $XES_TAIL_SEPARATE"
        
        # 1.创建三方组件仓库
        if [[ $handle == $Handle_CreatStore ]]; then
        creatRemoteStoreAction
        
        # 2.Clone仓库内容到本地
        elif [[ $handle == $Handle_git_clone ]]; then
        gitCloneAction
        
        # 3.添加LICENSE
        elif [[ $handle == $Handle_AddLICENSE ]]; then
        addLICENSEAction
        
        # 4.打开LICENSE
        elif [[ $handle == $Handle_OpenLICENSE ]]; then
        openLICENSEAction
        
        # 5.添加README.md
        elif [[ $handle == $Handle_AddREADME_md ]]; then
        addReadmeMDAction
        
        # 6.打开README.md
        elif [[ $handle == $Handle_OpenREADME_md ]]; then
        openReadmeMDAction
        
        # 7.创建podspec
        elif [[ $handle == $Handle_CreatPodspec ]]; then
        creatPodspecAction
        
        # 8.打开podspec
        elif [[ $handle == $Handle_OpenPodspec ]]; then
        openPodspecAction
        
        # 9.推送到集团远程仓库
        elif [[ $handle == $Handle_PushTALRemote ]]; then
        pushTALRemoteAction
        
        # 10.本地repo添加source
        elif [[ $handle == $Handle_pod_repo_add ]]; then
        podRepoAddAction
        
        # 11.集团仓库中创建对应的tag
        elif [[ $handle == $Handle_CreatStoreTag ]]; then
        echo "还没创建！！！！！！！！！！！！"
        
        # 12.推送repo版本
        elif [[ $handle == $Handle_pod_repo_push ]]; then
        podRepoPushAction
        
        else
            echo "!!!输入错误，请重新输入!!!"
            echo "!!!输入错误，请重新输入!!!"
        fi
        cd $RootPath

        echo "$XES_TAIL_SEPARATE  执行$handle 完成 $XES_TAIL_SEPARATE"
    else
        echo "!!!输入错误，请重新输入!!!"
        echo "!!!输入错误，请重新输入!!!"
        echo "!!!输入错误，请重新输入!!!"
    fi
}


#############主函数################
function main()
{
    #主函数
    while :
    do
        homeHandle
        cd $RootPath
    done
}

main
