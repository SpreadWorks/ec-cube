#!/bin/sh

BASE_DIR=$(cd $(dirname $0); pwd)
cd ${BASE_DIR}

# .gitignore の最終行にcomposer関連のファイルを追加
if ! grep -q 'composer.json' .gitignore; then
	echo 'composer.json' >> .gitignore
fi

if ! grep -q 'composer.lock' .gitignore; then
	echo 'composer.lock' >> .gitignore
fi

# composer関連のファイルを削除
git rm composer.json
git rm composer.lock


# 不要なファイルを削除
git rm -r app/Plugin/AnnotatedRouting
git rm -r app/Plugin/EntityExtension
git rm -r app/Plugin/EntityForm
git rm -r app/Plugin/FormExtension
git rm -r app/Plugin/HogePlugin
git rm -r app/Plugin/MigrationSample
git rm -r app/Plugin/PurchaseProcessors
git rm -r app/Plugin/QueryCustomize

# html ディレクトリをドキュメントルートにする
if ! grep -q '/html/' app/config/eccube/packages/framework.yaml; then
	sed -i -e "s#'/html/#'/#g" app/config/eccube/packages/framework.yaml
fi

# index.php の追加
if [ ! -f html/index.php ]; then
	echo '<?php require_once "../index.php";' > html/index.php
fi

if [ ! -f html/.htaccess ]; then
	cp .htaccess html/
fi

git add .
git commit -m 'customized'
git push origin

