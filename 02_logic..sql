CREATE OR REPLACE PACKAGE pkg_sales_mgmt IS
    -- Yeni mehsul elave eden prosedur
    PROCEDURE sp_add_prod(
        p_id   IN NUMBER,
        p_name IN VARCHAR2,
        p_cat  IN VARCHAR2,
        p_sub  IN VARCHAR2,
        p_cost IN NUMBER,
        p_list IN NUMBER
    );

    -- Müþteri seqmentini qaytaran funksiya
    FUNCTION fn_cust_seg(p_cid IN NUMBER) RETURN VARCHAR2;
END pkg_sales_mgmt;
/

-- 2. PAKET GÖVDeSÝ 
CREATE OR REPLACE PACKAGE BODY pkg_sales_mgmt IS

    -- Prosedur: Yeni mehsulun yoxlanýþla elave edilmesi
    PROCEDURE sp_add_prod(
        p_id   IN NUMBER,
        p_name IN VARCHAR2,
        p_cat  IN VARCHAR2,
        p_sub  IN VARCHAR2,
        p_cost IN NUMBER,
        p_list IN NUMBER
    ) IS
    BEGIN
        IF p_list < p_cost THEN
            RAISE_APPLICATION_ERROR(-20001, 'Satýþ qiym?ti maya d?y?rind?n aþaðý ola bilm?z!');
        ELSE
            INSERT INTO Products (product_id,
                                  product_name, 
                                  category, 
                                  sub_category, 
                                  cost_price, 
                                  list_price)
            VALUES (p_id, 
                    p_name, 
                    p_cat, 
                    p_sub, 
                    p_cost, 
                    p_list);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('M?hsul ?lav? edildi: ' || p_name);
        END IF;
    END sp_add_prod;

    -- Funksiya: Müþteri xerclemesine göre seqment teyini
    FUNCTION fn_cust_seg(p_cid IN NUMBER) RETURN VARCHAR2 IS
        v_spend NUMBER;
        v_res   VARCHAR2(20);
    BEGIN
        SELECT SUM((quantity * unit_price) * (1 - discount_percent/100))
        INTO v_spend
        FROM Sales
        WHERE customer_id = p_cid AND order_status = 'Delivered';

        IF v_spend >= 5000 THEN v_res := 'Gold (VIP)';
        ELSIF v_spend >= 2000 THEN v_res := 'Silver';
        ELSIF v_spend > 0 THEN v_res := 'Bronze';
        ELSE v_res := 'No Activity';
        END IF;

        RETURN v_res;
    EXCEPTION
        WHEN OTHERS THEN RETURN 'Not Found';
    END fn_cust_seg;

END pkg_sales_mgmt;
/

--Products cedvelinden melumat silinende deleted_products cedveline yazan trigger
CREATE OR REPLACE TRIGGER trg_arch_prod
BEFORE DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Deleted_Products (
        product_id, product_name, category, sub_category, 
        cost_price, list_price, deleted_by
    )
    VALUES (
        :OLD.product_id, :OLD.product_name, :OLD.category, :OLD.sub_category, 
        :OLD.cost_price, :OLD.list_price, USER
    );
END;
/

