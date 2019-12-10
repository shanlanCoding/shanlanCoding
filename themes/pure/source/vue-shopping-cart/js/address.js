new Vue({
	el:'.container',
	data:{
		addressList:[],
		limitNumber:3,
		currentIndex:0,
		shoppingMethod:1,
		pindex:0
	},
	mounted:function(){
		this.$nextTick(function(){
			this.getAddressList();
		});
	},
	computed:{
		filterAddress:function(){
			return this.addressList.slice(0,this.limitNumber);
		}
	},
	methods:{
		getAddressList:function(){
			var _this=this;
			this.$http.get("data/address.json").then(function(response){
				var res = response.data;
				if(res.status=="0"){
					_this.addressList=res.result;
				}
			});
		},
		setDefault:function(addressId){
			this.addressList.forEach(function(address,index){
				if(address.addressId==addressId){
					address.isDefault=true;
				}else{
					address.isDefault=false;
				}
			});
		},
		delProduct:function(){
			this.addressList.splice(this.pindex,1);
		},
		addProduct:function(){
	     this.addressList.unshift({
	      "addressId":"100006",
	      "userName":"陈杰",
	      "streetName":"深圳市南山区",
	      "postCode":"100001",
	      "tel":"123355678901",
	      "isDefault":false
	    });
	     this.limitNumber=this.addressList.length;
		},
		showOrHide:function(limitNumber){
			if(this.limitNumber==3){
				this.limitNumber=this.addressList.length;
			}else{
				this.limitNumber=3;
			}
		}
	}
});