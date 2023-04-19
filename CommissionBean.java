/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package FudosanBean;

/**
 *
 * @author hangt
 */
public class CommissionBean {

    private int commissionId;
    private int contractId;

    public int getCommissionId() {
        return commissionId;
    }

    public void setCommissionId(int commissionId) {
        this.commissionId = commissionId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public int getCommission_fee() {
        return commission_fee;
    }

    public void setCommission_fee(int commission_fee) {
        this.commission_fee = commission_fee;
    }
    private int companyId;
    private int commission_fee;

}
