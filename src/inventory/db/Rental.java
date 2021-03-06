/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */

package inventory.db;

import java.util.List;


import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;


/**
 * GAE ENTITY UTIL CLASS: "Rental" <br>
 * PARENT: NONE <br>
 * KEY: A long Id generated by GAE <br>
 * FEATURES: <br>
 * - "name" a {@link String} with the name record for the rental<br>
 * - "description" a {@link String} with the description record for the rental<br>
 * - "price" a {@link String} with the price record for the rental<br>
 * - "isRented" a {@link String} with the is Rented record for the rental<br>
 */

public class Rental {

	//
	// SECURITY
	//

	/**
	 * Private constructor to avoid instantiation.
	 */
	private Rental() {
	}

	//
	// KIND
	//

	/**
	 * The name of the Permit ENTITY KIND used in GAE.
	 */
	private static final String ENTITY_KIND = "Rental";

	//
	// KEY
	//

	/**
	 * Return the Key for a given Permit id given as String.
	 * 
	 * @param recordID A string with the rental ID (a long).
	 * @return the Key for this rentalID.
	 */
	public static Key getKey(String rentalID) {
		long id = Long.parseLong(rentalID);
		Key rentalKey = KeyFactory.createKey(ENTITY_KIND, id);
		return rentalKey;
	}

	/**
	 * Return the string ID corresponding to the key for the rental.
	 * 
	 * @param record The GAE Entity storing the rental.
	 * @return A string with the rental ID (a long).
	 */
	public static String getStringID(Entity product) {
		return Long.toString(product.getKey().getId());
	}

	//
	// ATTRIBUTES
	//

	/**
	 * The property name for the <b>name</b> value of the rental.
	 */
	private static final String NAME_PROPERTY = "Name";

	/**
	 * The property description for the <b>description</b> value of the rental.
	 */
	private static final String DESCRIPTION_PROPERTY = "Description";
	
	/**
	 * The property price for the <b>price</b> value of the rental.
	 */
	private static final String PRICE_PROPERTY = "Price";
	
	/**
	 * The property isRented for the <b>isRented</b> value of the rental.
	 */
	private static final String ISRENTED_PROPERTY = "IsRented";
	
	
	
	
	
	
	//
	// GETTERS
	//
	
	
	
	/**
	 * Return the name for the rental.
	 * 
	 * @param rental The GAE Entity storing the name
	 * @return the name in the product.
	 */
	public static String getName(Entity rental) {
		Object name = rental.getProperty(NAME_PROPERTY);
		if (name == null)
			name = "";
		return (String) name;
	}
	
	
	/**
	 * Return the description for the rental.
	 * 
	 * @param rental The GAE Entity storing the description
	 * @return the description in the rental.
	 */
	public static String getDescription(Entity rental) {
		Object description = rental.getProperty(DESCRIPTION_PROPERTY);
		if (description == null)
			description = "";
		return (String) description;
	}
	
	
	/**
	 * Return the price for the rental.
	 * 
	 * @param rental The GAE Entity storing the price
	 * @return the price in the rental.
	 */
	public static String getPrice(Entity rental) {
		Object price = rental.getProperty(PRICE_PROPERTY);
		if (price == null)
			price = "";
		return (String) price;
	}
	
	
	/**
	 * Return the isRented for the rental.
	 * 
	 * @param rental The GAE Entity storing the isRented
	 * @return the isRented in the rental.
	 */
	public static String getIsRented(Entity rental) {
		Object isRented = rental.getProperty(ISRENTED_PROPERTY);
		if (isRented == null)
			isRented = "";
		return (String) isRented;
	}
	
	
	//
	// SETTERS
	//
	
	/**
	 * Set the isRented for the rental.
	 * 
	 * @param rental The GAE Entity storing the isRented
	 * 
	 */
	public static boolean setIsRented(String rentalID, String isRented) {
		Entity rental = getRental(rentalID);
		try {
			rental.setProperty(ISRENTED_PROPERTY, isRented);
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(rental);
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	

	

	//
	// CREATE RENTAL
	//

	/**
	 * Create a new rental if the rentalID is correct and none exists with this id.
	 * 
	 * @param name The name for this rental.
	 * @param description The description for this rental.
	 * @param price The price for this rental.
	 * @param isRented The isRented for this rental.
	 * 
	 * @return the Entity created with this id or null if error
	 */
	public static Entity createRental(String name, String description,  String price,  String isRented) {
		Entity rental = null;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Transaction txn = datastore.beginTransaction();
		try {

			rental = new Entity(ENTITY_KIND);
			rental.setProperty(NAME_PROPERTY, name);
			rental.setProperty(DESCRIPTION_PROPERTY, description);
			rental.setProperty(PRICE_PROPERTY, price);
			rental.setProperty(ISRENTED_PROPERTY, isRented);
			
			datastore.put(rental);

			txn.commit();
		} catch (Exception e) {
			return null;
		} finally {
			if (txn.isActive()) {
				txn.rollback();
			}
		}

		return rental;
	}

	//
	// GET RENTAL
	//

	/**
	 * Get the rental based on a string containing its long ID.
	 * 
	 * @param rentalID a {@link String} containing the ID key (a <code>long</code> number)
	 * @return A GAE {@link Entity} for the Rental or <code>null</code> if none or error.
	 */
	public static Entity getRental(String rentalID) {
		Entity rental = null;
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			long id = Long.parseLong(rentalID);
			Key rentalKey = KeyFactory.createKey(ENTITY_KIND, id);
			rental = datastore.get(rentalKey);
		} catch (Exception e) {
			// TODO log the error
		}
		return rental;
	}


	//
	// UPDATE RENTAL
	//

	/**
	 * Update the current description of the rental
	 * 
	 * @param rentalID A string with the rental ID (a long).
	 * @param name The name of the rental as a String.
	 * @param description The description of the rental as a String.
	 * @param price The price of the rental as a String.
	 * @param isRented The isrented value of the rental as a String.
	 * @return true if succeed and false otherwise
	 */
	public static boolean updateRental(String rentalID, String name, String description,  String price,  String isRented) {
		Entity rental = null;
		try {
			rental = getRental(rentalID);
			rental.setProperty(NAME_PROPERTY, name);
			rental.setProperty(DESCRIPTION_PROPERTY, description);
			rental.setProperty(PRICE_PROPERTY, price);
			rental.setProperty(ISRENTED_PROPERTY, isRented);
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(rental);
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	//
	// DELETE RENTAL
	//

	/**
	 * Delete the rental if not linked to anything else.
	 * 
	 * @param rentalID A string with the rental ID (a long).
	 * @return True if succeed, false otherwise.
	 */
	public static boolean deleteRental(String rentalID) {
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.delete(getKey(rentalID));
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	//
	// QUERY RENTAL
	//

	/**
	 * Return the requested number of rentals (e.g. 100).
	 * 
	 * @param limit The number of rentals to be returned.
	 * @return A list of GAE {@link Entity entities}.
	 */
	public static List<Entity> getFirstRentals(int limit) {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query query = new Query(ENTITY_KIND);
		List<Entity> result = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(limit));
		return result;
	}

}
