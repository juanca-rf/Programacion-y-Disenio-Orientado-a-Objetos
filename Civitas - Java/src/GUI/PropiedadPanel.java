/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package GUI;
import civitas.*;

/**
 *
 * @author juanc
 */
public class PropiedadPanel extends javax.swing.JPanel {
    TituloPropiedad tituloPropiedad;
    /**
     * Creates new form PorpiedadPanel
     */
    public PropiedadPanel() {
        initComponents();
    }
    
    public void setPropiedad( TituloPropiedad titulo ){
        tituloPropiedad = titulo;
        TextHipotecado.setText( tituloPropiedad.getHipotecado()? "Si" : "No" );
        TextNombre.setText( tituloPropiedad.getNombre() );
        TextNumCasas.setText( Integer.toString(tituloPropiedad.getNumCasas()) );
        TextNumHoteles.setText( Integer.toString(tituloPropiedad.getNumHoteles()) );
        repaint();
        revalidate();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        etiqNombre = new javax.swing.JLabel();
        etiqNumCasas = new javax.swing.JLabel();
        etiqNumHoteles = new javax.swing.JLabel();
        etiqHipotecada = new javax.swing.JLabel();
        TextNombre = new javax.swing.JTextField();
        TextNumCasas = new javax.swing.JTextField();
        TextNumHoteles = new javax.swing.JTextField();
        TextHipotecado = new javax.swing.JTextField();

        etiqNombre.setText("Nombre");
        etiqNombre.setEnabled(false);

        etiqNumCasas.setText("Casas");
        etiqNumCasas.setEnabled(false);

        etiqNumHoteles.setText("Hoteles");
        etiqNumHoteles.setEnabled(false);

        etiqHipotecada.setText("Hipotecada");
        etiqHipotecada.setEnabled(false);

        TextNombre.setText("jTextField1");
        TextNombre.setEnabled(false);

        TextNumCasas.setText("jTextField2");
        TextNumCasas.setEnabled(false);

        TextNumHoteles.setText("jTextField3");
        TextNumHoteles.setEnabled(false);

        TextHipotecado.setText("jTextField4");
        TextHipotecado.setEnabled(false);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(etiqHipotecada)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(TextHipotecado, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(etiqNumHoteles)
                            .addComponent(etiqNombre)
                            .addComponent(etiqNumCasas))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(TextNumHoteles, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(TextNombre, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(TextNumCasas, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap(26, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(etiqNombre)
                    .addComponent(TextNombre, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(etiqNumCasas))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(TextNumCasas, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(TextNumHoteles, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(etiqNumHoteles))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(TextHipotecado, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(etiqHipotecada))
                .addContainerGap(22, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextField TextHipotecado;
    private javax.swing.JTextField TextNombre;
    private javax.swing.JTextField TextNumCasas;
    private javax.swing.JTextField TextNumHoteles;
    private javax.swing.JLabel etiqHipotecada;
    private javax.swing.JLabel etiqNombre;
    private javax.swing.JLabel etiqNumCasas;
    private javax.swing.JLabel etiqNumHoteles;
    // End of variables declaration//GEN-END:variables
}
