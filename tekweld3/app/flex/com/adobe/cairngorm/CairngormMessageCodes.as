/*

Copyright (c) 2007. Adobe Systems Incorporated.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of Adobe Systems Incorporated nor the names of its
    contributors may be used to endorse or promote products derived from this
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

@ignore
*/
package com.adobe.cairngorm
{
	/**
	 * Stores Cairngorm message codes.
	 * 
	 * <p>All messages/error codes must match the regular expression:
	 *
	 * C\d{4}[EWI]
	 *
	 * 1. The application prefix e.g. 'C'.
	 * 
	 * 2. A four-digit error code that must be unique.
	 * 
	 * 3. A single character severity indicator
	 *    (E: error, W: warning, I: informational).</p>
	 */
	public class CairngormMessageCodes
	{
	   public static const SINGLETON_EXCEPTION : String = "Singleton exception";
	   public static const SERVICE_NOT_FOUND : String = "Service not found";
	   public static const COMMAND_ALREADY_REGISTERED : String = "Command already registered";
	   public static const COMMAND_NOT_FOUND : String = "Command not found";
	   public static const VIEW_ALREADY_REGISTERED : String = "View already registered";
	   public static const VIEW_NOT_FOUND : String = "View not found";
	   public static const REMOTE_OBJECT_NOT_FOUND : String = "Remote object not found";	
	   public static const HTTP_SERVICE_NOT_FOUND : String = "HTTP service not found";
	   public static const WEB_SERVICE_NOT_FOUND : String = "Web service not found";
	   public static const CONSUMER_NOT_FOUND : String = "Consumer not found";
	   public static const PRODUCER_NOT_FOUND : String = "Producer not found";
	   public static const DATA_SERVICE_NOT_FOUND : String = "Data service not found";
	   public static const ABSTRACT_METHOD_CALLED : String = "Abstract method called";
	   public static const COMMAND_NOT_REGISTERED : String = "Command not registered";
	}
}