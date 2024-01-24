# Play Integral
Play Integral is an on-chain loyalty card agreement that aims to make merchants spend less money to gain more influence and improve their business. Overall, businesses can do better and users can save more money.


## System Structure
### This is a schematic of the project
![chart](https://github.com/DankFang/On-chain-integration-system/tree/main/img/whiteboard_exported_image.png)
![label1](https://github.com/DankFang/On-chain-integration-system/tree/main/img/label1.jpg)
![label2](https://github.com/DankFang/On-chain-integration-system/tree/main/img/label2.jpg)

## [ERC7527]
# Shopping Credits

莫 忙

## 项目介绍

基于ERC-3525和ERC-7527的链上商家积分系统，旨在解决商家积分流动性和效果追踪溯源的问题。

## 步骤流程

###  社区：

1. 发放身份证明：社区leader进入系统，部署身份NFT合约，并向社区成员发放身份证明NFT。
2. 发放代币：由社区leader创建Ptoken合约，此合约发放此系统中的代笔给身份证明NFT的拥有者，并且每日限量且每人均分。
3. 组建Ptoken-ETH的Uniswap交易对，用于对Ptoken价值评估。
4. 引入ERC-7527协议：通过对社区身份证明NFT的包装，包装后的NFT才能进入商家进行消费。规则：包装次数越多，单次消耗Ptoken就越多。（防止用户持有NFT持续享受优惠）。

### 商家：

1. 广告：当社区人数足够多，将会吸引商家进入社区进行宣传，宣传方式为使用ETH购买Ptoken来销毁。每日销毁数量前十的商家将进行一定的展示，形成打榜效应。此机制实现了商家花钱打广告，用户Ptoken升值的情况。
2. 引入ERC-3525标准，商家在宣传的同时发放ERC-3525的SFT积分。

## 未来规划

惩罚机制：若用户在一段时间内未在此社区内宣传的任意商家进行消费，则社区将会没收其Ptoken并进行销毁；若在相当一段长的时间内未消费，则没收其NFT并进行销毁。

## 总结

此系统可以确保商家宣传效果，同时使得商家宣传的花销通过Ptoken-ETH交易对，使得用户能够获得收益。同时惩罚机制也会打击社区撸毛者，给予社区消费者极大便利。最终达到一个商家有效广告、用户实惠消费的场景！

[ERC7527]: <https://github.com/DankFang/ERC7527-UseHardhat>
