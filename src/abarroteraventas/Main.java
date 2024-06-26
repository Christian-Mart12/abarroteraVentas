package abarroteraventas;

import java.util.ArrayList;
import java.util.Scanner;

/**
 *
 * @author Alexis Reyes
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        menu();
    }

    public static void menu() {
        int opc = 0;
        productos product = new productos();
        ArrayList<productos> listaP = new ArrayList<>();
        ArrayList<ventas> listaV = new ArrayList<>();
        ventas venta = new ventas();
        do {
            System.out.println("\n=====================================");
            System.out.println("      Sistema Gestor de Ventas");
            System.out.println("=====================================\n");

            System.out.println("1. Registrar una nueva venta");
            System.out.println("2. Consultar venta por ID");
            System.out.println("3. Eliminar una venta");
            System.out.println("4. Agregar un producto");
            System.out.println("5. Agregar un producto a una venta");
            System.out.println("6. Eliminar un producto de una venta");
            System.out.println("7. Consultar el stock de un producto");
            System.out.println("8. Actualizar el precio de un producto");
            System.out.println("0. Salir \n");
            Scanner entrada = new Scanner(System.in);
            System.out.print("Opción: ");
            opc = entrada.nextInt();

            switch (opc) {
                case 1:
                    venta.registrarVenta(venta, product, listaP, listaV);
                    break;
                case 2:
                    System.out.print("Introduce el ID de la venta: ");
                    int idVenta = entrada.nextInt();
                    venta.consultarVentaPorID(listaV, idVenta);
                    break;
                case 3:
                    System.out.print("Ingrese el ID de la venta a eliminar: ");
                    int idEliminar = entrada.nextInt();
                    venta.eliminarVenta(listaV, listaP, idEliminar);
                case 4:
                    product.registrarProductos(listaP);
                    break;
                case 5:
                    System.out.print("Ingrese el ID de la venta: ");
                    idVenta = entrada.nextInt();
                    System.out.print("Ingrese el ID del producto: ");
                    int idProducto = entrada.nextInt();
                    venta.agregarProductoAVenta(listaV, listaP, idVenta, idProducto);
                    break;
                case 6:
                    System.out.print("Ingrese el ID de la venta: ");
                    int idVentaEliminar = entrada.nextInt();
                    System.out.print("Ingrese el ID del producto a eliminar: ");
                    int idProductoEliminar = entrada.nextInt();
                    venta.eliminarProductoDeVenta(listaV, listaP, idVentaEliminar, idProductoEliminar);
                    break;
                case 7:
                    product.listaProductos(listaP);
                    break;
                case 8:
                    product.actualizarPrecio(product, listaP);
                    break;
                case 0:
                    System.out.println("Saliendo del sistema...");
                    break;
                default:
                    System.out.println("Opción no válida");
                    break;
            }
        } while (opc != 0);
    }
}
