const { expect } = require("chai");
const hre = require("hardhat");
const { ethers } = require("hardhat")
const {
  loadFixture,
  time,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("Factory",function(){
    async function deployFactory(){
        // 
        const ERC7527Factory = await ethers.getContractFactory("ERC7527Factory");
        const erc7527Factory = await ERC7527Factory.deploy();

        //   
        const ERC7527Agency = await ethers.getContractFactory("ERC7527Agency");
        const erc7527Agency = await ERC7527Agency.deploy();
        //   
        const ERC7527App = await ethers.getContractFactory("ERC7527App");
        const erc7527App = await ERC7527App.deploy();

        // 
        const UsePtokenWith7527 = await ethers.getContractFactory("usePtokenWith7527",{
            value:ethers.parseEther("10"), 
        });
        // 填入对应的 _ptokenInstance, _erc7527FactoryAddr
        const usePtokenWith7527 = await UsePtokenWith7527.deploy();

        // 
        const Ptoken = await ethers.getContractFactory("ptoken");
        // 在这里部署的时候应该填入你对应的 _root, _personAmount, name,  symbol
        let _root
        let _personAmount
        let name
        let symbol
        const ptoken = await Ptoken.deploy();

        return {erc7527Factory,erc7527Agency,erc7527App,usePtokenWith7527,ptoken};
        
    }
    it("use deployWrap, wrap , unwrap", async function(){
        const {erc7527Factory,erc7527Agency,erc7527App,usePtokenWith7527,ptoken} = await loadFixture(deployFactory)
        
        console.log("erc7527Factory Address is   "+erc7527Factory.target);//0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
        console.log("erc7527Agency Address is    "+erc7527Agency.target);//0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
        console.log("erc7527App Address is       "+erc7527App.target);//0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
        const bytesData = ethers.encodeBytes32String("")
        // 以ptoken作为包装解包装的资产 
        // 铸造手续费万分比，此处设置为 10
        //  销毁手续费万分比，此处设置为 10
        const AgencySettings = [erc7527Agency.target,
        [ptoken.target,ethers.parseEther('0.1'),erc7527Agency.target,'10','10'],
        '0x',
        '0x'
        ]
        const AppSettings = [erc7527App.target,'0x','0x']
        await usePtokenWith7527.useDeployWrap(erc7527Factory.target,AgencySettings,AppSettings,'0x');
        const appInstance  = await usePtokenWith7527.appInstance();
        const agencyInstance  = await usePtokenWith7527.agencyInstance();

        console.log("appInstance Address is     " + appInstance);
        console.log("agencyInstance Address is  " + agencyInstance);

        // 填入相应的 tokenID
        let tokenID
        const warpReturn = await usePtokenWith7527.useWarp(tokenID);
        console.log(warpReturn);

        // 修改相应的 tokenID
        // tokenID = 
        await usePtokenWith7527.useUnwarp(tokenID);
        
    })
})