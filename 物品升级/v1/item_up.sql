/*
这个是物品升级表
下面的中文部分除去【物品序号】和【成品序号】别的都可以改动
具体数据因为每个人都不一样 所以就不提供了
如果没有的话可以简单的写一个生成语句生成一个
尽量不要直接导入  要不会死人的 慢的要死有木有。。
*/

SET FOREIGN_KEY_CHECKS=0;


DROP TABLE IF EXISTS `item_up`;
CREATE TABLE `item_up` (
  `物品序号` int(11) NOT NULL,
  `成品序号` int(11) NOT NULL DEFAULT '0',
  `材料1` int(11) NOT NULL DEFAULT '0',
  `数量1` int(11) NOT NULL DEFAULT '0',
  `材料2` int(11) NOT NULL DEFAULT '0',
  `数量2` int(11) NOT NULL DEFAULT '0',
  `材料3` int(11) NOT NULL DEFAULT '0',
  `数量3` int(11) NOT NULL DEFAULT '0',
  `材料4` int(11) NOT NULL DEFAULT '0',
  `数量4` int(11) NOT NULL DEFAULT '0',
  `材料5` int(11) NOT NULL DEFAULT '0',
  `数量5` int(11) NOT NULL DEFAULT '0',
  `几率` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`物品序号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


