﻿
&Перед("ПриСозданииНаСервере")
Процедура УУ_ПриСозданииНаСервере(Форма)
	
	Если Форма.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаДокументаНаРеализацию" ИЛИ
		Форма.ИмяФормы = "Документ.СчетФактураВыданный.Форма.ФормаДокументаНаАванс" ИЛИ
		Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокументаОбщая" ИЛИ
		Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокументаОбщая" Тогда
		НовыйЭлемент = Форма.Элементы.Добавить("АвтообновленияЗаблокированы", Тип("ПолеФормы"),Форма.Элементы.ГруппаКомментарийОтветственный);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
		НовыйЭлемент.ВидФлажка = ВидФлажка.Выключатель;
		НовыйЭлемент.ПутьКДанным = "Объект.АвтообновленияЗаблокированы";
	КонецЕсли;
	Если Форма.ИмяФормы = "Документ.СчетФактураПолученный.Форма.ФормаДокументаНаПоступление" Тогда
		НовыйЭлемент = Форма.Элементы.Добавить("АвтообновленияЗаблокированы", Тип("ПолеФормы"));
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
		НовыйЭлемент.ВидФлажка = ВидФлажка.Выключатель;
		НовыйЭлемент.ПутьКДанным = "Объект.АвтообновленияЗаблокированы";
	КонецЕсли;
	Если Форма.ИмяФормы = "Документ.СчетФактураПолученный.Форма.ФормаДокументаНаАванс" Тогда
		НовыйЭлемент = Форма.Элементы.Добавить("АвтообновленияЗаблокированы", Тип("ПолеФормы"),Форма.Элементы.ГруппаПодвал);
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
		НовыйЭлемент.ВидФлажка = ВидФлажка.Выключатель;
		НовыйЭлемент.ПутьКДанным = "Объект.АвтообновленияЗаблокированы";
	КонецЕсли; 
	
КонецПроцедуры
