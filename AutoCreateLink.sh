#! /usr/bin/bash
cd `dirname ${0}`;
rootDir=`pwd`;

	# 現階層の*.mdファイルを配列に格納
	function CreateMdFilesArrayList(){
		local mdFilesArray=();
		mdFilesArray+=(`ls`);
		echo ${mdFilesArray[@]};
	}

	# mdファイルごとにリンク文字列を作成
	# README_WK.mdに追記していく。
	# 第一引数: フォルダ名
	# 第二引数: mdファイルの配列
	function CreateLinkString(){
		# ディレクトリ名
		local dirName=${1};
		# すべての引数を配列に格納
		local args=(${@});

		# 引数の数を計算する。
		argsCount=`expr ${#} - 1`;

		# リンク文字列の初期化
		local linkString;

		if [ ${dirName} != "." ] && [ ${dirName} != "./mdFiles" ]; then
			header="## "${dirName#mdFiles/}"\n";
			header=${header/_/\\_};
			linkString+=${header};

			for argsNo in `seq 1 ${argsCount}`;do
				local fileName=${args[${argsNo}]};
				pageName=${fileName/.md};
				linkString+="- ["${pageName/_/\\_}"]";
				linkString+="("${dirName#./}"/"${fileName}")\n";
			done
		fi
		echo -e ${linkString};
	}

# メインメソッド
function Main(){
	# mdFile格納用の配列の初期化
	local mdFilesArray=();

	# READMEの9行目までを別ファイルに切り分け
	head -n 9 README.md > README_WK.md;

	# 下の階層のフォルダに移動する。
	for dir in `find mdFiles -type d`; do 
		pushd ${dir} 2>&1>/dev/null;

		# 現階層の*.mdファイルを配列に格納
		mdFilesArray=(`CreateMdFilesArrayList`);
		CreateLinkString ${dir} ${mdFilesArray[@]}>>${rootDir}/README_WK.md;
		popd 2>&1>/dev/null;
	done
}
Main;

