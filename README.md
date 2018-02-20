# module-kanmusu-list

KcWiki 模块:舰娘列表

仅供页面：舰娘列表调用

仅能调用main函数，传入参数有两种：1和99，分别获取舰船1级和99级的数据

调用方法，需要配合模板:舰娘列表/页首和模板:页尾使用

使用方法如下：

```mediawiki
{{舰娘列表/页首}}
{{#invoke: 舰娘列表|main|1}}
{{页尾|html}}
```

```mediawiki
{{舰娘列表/页首}}
{{#invoke: 舰娘列表|main|99}}
{{页尾|html}}
```
