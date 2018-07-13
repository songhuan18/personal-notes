##### 1.先安装npm，如果已安装忽略
```shell
brew install node
brew install npm
```
##### 2.安装asar
```shell
npm install -g asar
```
##### 3.找到app.asar
```shell
cd /Applications/StarUML.app/Contents/Resources
# app.asar 在Resource目录下
```
##### 4.解压app.asar
```shell
asar extract app.asar app
```
##### 5.修改源码代码
```shell
vim app/src/engine/license-manager.js
```
修改后的源码：
```js
checkLicenseValidity () {
  this.validate().then(() => {
    setStatus(this, true)
  }, () => {
    // setStatus(this, false)
    // UnregisteredDialog.showDialog()
    setStatus(this, true)
  })
}

/**
 * Check the license key in server and store it as license.key file in local
 *
 * @param {string} licenseKey
 */
register (licenseKey) {
  return new Promise((resolve, reject) => {
    $.post(app.config.validation_url, {licenseKey: licenseKey})
      .done(data => {
        var file = path.join(app.getUserPath(), '/license.key')
        fs.writeFileSync(file, JSON.stringify(data, 2))
        licenseInfo = data
        setStatus(this, true)
        resolve(data)
      })
      .fail(err => {
        setStatus(this, true)
        //if (err.status === 499) { /* License key not exists */
        //  reject('invalid')
        // } else {
        //  reject()
        // }
      })
  })
}
```
##### 6.重新打包替换原来的app.asar
```shell
asar pack app app.asar
```
打开StarUML, help->Enter License Key
提示你：You already have valid license，即破解成功
