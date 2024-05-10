/**
 *Submitted for verification at blastscan.io on 2024-05-08
*/

/**
 *Submitted for verification at Etherscan.io on 2024-05-06
*/

/*
Website: https://basevsblast.xyz
Telegram: https://t.me/basevsblast
Twitter: https://twitter.com/BlastVSBase
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Ownable is Context {

    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any _account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

enum YieldMode {
    AUTOMATIC,
    VOID,
    CLAIMABLE
}

enum GasMode {
    VOID,
    CLAIMABLE
}

interface IBlast{
    // configure
    function configureContract(address contractAddress, YieldMode _yield, GasMode gasMode, address governor) external;
    function configure(YieldMode _yield, GasMode gasMode, address governor) external;

    // base configuration options
    function configureClaimableYield() external;
    function configureClaimableYieldOnBehalf(address contractAddress) external;
    function configureAutomaticYield() external;
    function configureAutomaticYieldOnBehalf(address contractAddress) external;
    function configureVoidYield() external;
    function configureVoidYieldOnBehalf(address contractAddress) external;
    function configureClaimableGas() external;
    function configureClaimableGasOnBehalf(address contractAddress) external;
    function configureVoidGas() external;
    function configureVoidGasOnBehalf(address contractAddress) external;
    function configureGovernor(address _governor) external;
    function configureGovernorOnBehalf(address _newGovernor, address contractAddress) external;

    // claim yield
    function claimYield(address contractAddress, address recipientOfYield, uint256 amount) external returns (uint256);
    function claimAllYield(address contractAddress, address recipientOfYield) external returns (uint256);

    // claim gas
    function claimAllGas(address contractAddress, address recipientOfGas) external returns (uint256);
    function claimGasAtMinClaimRate(address contractAddress, address recipientOfGas, uint256 minClaimRateBips) external returns (uint256);
    function claimMaxGas(address contractAddress, address recipientOfGas) external returns (uint256);
    function claimGas(address contractAddress, address recipientOfGas, uint256 gasToClaim, uint256 gasSecondsToConsume) external returns (uint256);

    // read functions
    function readClaimableYield(address contractAddress) external view returns (uint256);
    function readYieldConfiguration(address contractAddress) external view returns (uint8);
    function readGasParams(address contractAddress) external view returns (uint256 etherSeconds, uint256 etherBalance, uint256 lastUpdated, GasMode);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }


}

interface IDexSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDexSwapPair {

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IDexSwapRouter {

    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

}

abstract contract ReentrancyGuard {
   
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

contract BVB is Context, IERC20, ReentrancyGuard, Ownable {

    using SafeMath for uint256;
   
    address public marketingWallet = address(0xD5d666705cf7f30945BA50c18bc3D1B809D827C7);
    address public developerWallet;

    struct DisFee {
        uint Reward;
        uint Marketing;
        uint subtotal;
    }

    DisFee public buyFee;
    DisFee public sellFee;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances; 

    mapping (address => bool) public isTaxFree;
    mapping (address => bool) public isMarketPair;

    mapping(address => bool) public isDividendExempt;

    string private constant _name = "Base Vs Blast";
    string private constant _symbol = "$BVB";
    uint8 private constant _decimals = 18; 

    uint256 private _totalSupply = 1_000_000 * 10**_decimals;

    uint256 public maxTransaction =  _totalSupply.mul(3).div(100);
    uint256 public maxWallet = _totalSupply.mul(3).div(100);

    uint256 public swapThreshold = _totalSupply.mul(5).div(1000);

    bool public swapEnabled = true;
    bool public swapbylimit = false;

    bool public AntiWhaleActive = true;
    
    address public pair;
    
    IDexSwapPair public pairContract;
    IDexSwapRouter public dexRouter;
    
    bool public launched;
    bool public autoReward;

    // distributor

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }
   
    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    mapping (address => uint256) shareholderClaims;

    mapping (address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public currentIndex;

    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
    uint256 public minPeriod = 15 minutes;
    uint256 public minDistribution = 1 * (10 ** 9);
    uint256 public distributorGas = 500000;

    bool inSwap = false;

    modifier onlyGuard() {
        require(msg.sender == developerWallet,'Invalid Caller!');
        _;
    }

    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    event SwapTokensForETH(
        uint256 amountIn,
        address[] path
    );

    constructor() {

        IBlast blast = IBlast(0x4300000000000000000000000000000000000002);
        blast.configureAutomaticYield();

        developerWallet = msg.sender;

        dexRouter = IDexSwapRouter(0xBB66Eb1c5e875933D44DAe661dbD80e5D9B03035); 

        pair = IDexSwapFactory(dexRouter.factory()).createPair(
            dexRouter.WETH(),
            address(this)
        );

        pairContract = IDexSwapPair(pair);

        isMarketPair[pair] = true;

        buyFee = DisFee(0,30,30);
        sellFee = DisFee(0,30,30);

        isDividendExempt[msg.sender] = true;
        isDividendExempt[pair] = true;
        isDividendExempt[address(this)] = true;
        isDividendExempt[address(0xDead)] = true;
        isDividendExempt[address(0x0)] = true;

        isTaxFree[msg.sender] = true;
        isTaxFree[address(this)] = true;

        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);

    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
       return _balances[account];     
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    receive() external payable {}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {

        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
    
        if (inSwap) {
            return _basicTransfer(sender, recipient, amount);
        }
        else {

            if(!isTaxFree[sender] && !isTaxFree[recipient] && AntiWhaleActive) {
                require(launched,"Not Launched!");
                require(amount <= maxTransaction, "Exceeds maxTxAmount");
                if(!isMarketPair[recipient]) {
                    require(balanceOf(recipient).add(amount) <= maxWallet, "Exceeds maxWallet");
                }
            }            

            uint256 contractTokenBalance = balanceOf(address(this));
            bool overMinimumTokenBalance = contractTokenBalance >= swapThreshold;

            if (overMinimumTokenBalance && 
                !inSwap && 
                !isMarketPair[sender] && 
                swapEnabled &&
                !isTaxFree[sender] &&
                !isTaxFree[recipient]
                ) {
                swapBack(contractTokenBalance);
            }
            
            _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

            uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);

            _balances[recipient] = _balances[recipient].add(finalAmount);

            if(!isDividendExempt[sender]) setShare(sender, balanceOf(sender));
            if(!isDividendExempt[recipient]) setShare(recipient, balanceOf(recipient));

            process(distributorGas);

            emit Transfer(sender, recipient, finalAmount);
            return true;

        }

    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
        if(isTaxFree[sender] || isTaxFree[recipient]) {
            return true;
        }
        else if (isMarketPair[sender] || isMarketPair[recipient]) {
            return false;
        }
        else {
            return false;
        }
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        
        uint feeAmount;

        unchecked {

            // buy transaction
            if(isMarketPair[sender]) { 
                feeAmount = amount.mul(buyFee.subtotal).div(100);
            } 
            // sell transaction
            else if(isMarketPair[recipient]) { 
                feeAmount = amount.mul(sellFee.subtotal).div(100);
            }

            if(feeAmount > 0) {
                _balances[address(this)] = _balances[address(this)].add(feeAmount);
                emit Transfer(sender, address(this), feeAmount);
            }

            return amount.sub(feeAmount);
        }
    }


    function swapBack(uint contractBalance) internal swapping {

        if(swapbylimit) contractBalance = swapThreshold;

        uint _rewardShare    = buyFee.Reward.add(sellFee.Reward);
        uint _marketingShare = buyFee.Marketing.add(sellFee.Marketing);

        uint _totalShares    = _rewardShare.add(_marketingShare);

        uint256 initialBalance = address(this).balance;
        swapTokensForEth(contractBalance);
        uint256 amountReceived = address(this).balance.sub(initialBalance);

        uint EthForReward = amountReceived.mul(_rewardShare).div(_totalShares);
        uint EthForMarketing = amountReceived.sub(EthForReward);

        if (EthForReward > 0) {
            totalDividends = totalDividends.add(EthForReward);
            dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(EthForReward).div(totalShares));
        }

        if (EthForMarketing > 0) {
            (bool os,) = payable(marketingWallet).call{value: EthForMarketing}("");
            os = true;  //bypass check
        }

    }
    

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = dexRouter.WETH();

        _approve(address(this), address(dexRouter), tokenAmount);

        // make the swap
        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            1, 
            path,
            address(this), 
            block.timestamp + 30
        );
        
        emit SwapTokensForETH(tokenAmount, path);
    }
    
    function setMarketingWallet(address _newWallet) external onlyOwner {
        marketingWallet = _newWallet;
    }

    function setDeveloperWallet(address _newWallet) external onlyGuard {
        developerWallet = _newWallet;
    }

    function manuallyProcessReward() external nonReentrant() {
        process(distributorGas.mul(uint256(2)));
    }

    function clearStuckedBalance(address recipient,bool _flush) external onlyGuard nonReentrant() { 
        if(_flush) {
            payable(recipient).transfer(address(this).balance);
        }
        else {
            
            uint seeDelta = (totalDividends).sub(totalDistributed);
            uint transferable = address(this).balance.sub(seeDelta);

            if(transferable > 0) {
                payable(recipient).transfer(transferable);
            }
        }
    }

    function rescueTokens(address _token,address recipient,uint _amount) external onlyGuard nonReentrant() {
        (bool success, ) = address(_token).call(abi.encodeWithSignature('transfer(address,uint256)',  recipient, _amount));
        require(success, 'Token payment failed');
    }

    function isAutoRewardEnable(bool _status) external onlyGuard {
        autoReward = _status;
    }

    function setIsDividendExempt(address holder, bool exempt) external onlyGuard {
        require(holder != address(this) && !isMarketPair[holder]);
        isDividendExempt[holder] = exempt;

        if (exempt) {
            setShare(holder, 0);
        } else {
            setShare(holder, balanceOf(holder));
        }
    }

    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external onlyGuard {
        minPeriod = _minPeriod;
        minDistribution = _minDistribution;
    }

    function setDistributorSettings(uint256 gas) external onlyOwner {
        require(gas < 750000, "Gas must be lower than 750000");
        distributorGas = gas;
    }


    function setFeeSetting(uint _buyReward, uint _buyMarketing, uint _sellReward, uint _sellMarketing) external onlyOwner {
        uint buySub = _buyReward.add(_buyMarketing);
        uint sellSub = _sellReward.add(_sellMarketing);
        buyFee = DisFee(_buyReward,_buyMarketing,buySub);
        sellFee = DisFee(_sellReward,_sellMarketing,sellSub);
        require(buySub <= 35 && sellSub <= 35,"MAX FEE 35% EXCEEDED!");
    }   
        

    function setChargeFee(address _adr,bool _status) external onlyOwner {
        isTaxFree[_adr] = _status;
    }

    function openTrade() external onlyGuard() {
        require(!launched,"Already Enabled!");
        launched = true;
    }

    function setAntiWhalePercentage(uint256 _per) external onlyOwner() {
        require(_per >=  5 && AntiWhaleActive,"Minimum Limit is 0.5% or Whale Must be Active");
        maxTransaction = _totalSupply.mul(_per).div(1000);
        maxWallet = _totalSupply.mul(_per).div(1000);
    }

    function setSwapBackSettings(bool _enabled, bool _limited, uint _threshold)
        external
        onlyOwner
    {
        swapEnabled = _enabled;
        swapbylimit = _limited;
        swapThreshold = _threshold;
    }

    function removeLimits() external onlyOwner {
        maxTransaction = _totalSupply;
        maxWallet = _totalSupply;
        AntiWhaleActive = false;
    }

    function claimDividend() external nonReentrant() {
        distributeDividend(msg.sender);
    }

    //  Distributor

    function setShare(address shareholder, uint256 amount) internal {
        if(shares[shareholder].amount > 0){
            distributeDividend(shareholder);
        }

        if(amount > 0 && shares[shareholder].amount == 0){
            addShareholder(shareholder);
        }else if(amount == 0 && shares[shareholder].amount > 0){
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function process(uint256 gas) internal {
        
        if(!autoReward) return;

        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0) { return; }

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
            if(currentIndex >= shareholderCount){
                currentIndex = 0;
            }

            if(shouldDistribute(shareholders[currentIndex])){
                distributeDividend(shareholders[currentIndex]);
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }


    function shouldDistribute(address shareholder) internal view returns (bool) {
        return shareholderClaims[shareholder] + minPeriod < block.timestamp && getUnpaidEarnings(shareholder) > minDistribution;
    }

    function distributeDividend(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }

        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0){
            totalDistributed = totalDistributed.add(amount);
            shareholderClaims[shareholder] = block.timestamp;
            payable(shareholder).transfer(amount);
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
        }
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }


}