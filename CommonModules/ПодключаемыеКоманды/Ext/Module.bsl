﻿
&После("ПриСозданииНаСервере")
Процедура УУ_ПриСозданииНаСервере(Форма)
	Параметры = Форма.Параметры;	
	Если Параметры.Свойство("ДокументУУ") Тогда
		ДобавляемыеРеквизиты	= Новый Массив;
		
		Массив = Новый Массив;
		Массив.Добавить(ТипЗнч(Параметры.ДокументУУ));
		ОписаниеТиповС = Новый ОписаниеТипов(Массив);
		
		Реквизит_ДокументУУ = Новый РеквизитФормы("ДокументУУ",	ОписаниеТиповС,	, "Документ УУ");
		ДобавляемыеРеквизиты.Добавить(Реквизит_ДокументУУ);
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		Форма.ДокументУУ = Параметры.ДокументУУ; 
		
	КонецЕсли;
	
	ИгнорироватьБлокАвтообновления = Справочники.сабМониторВнедрения.ПолучитьЗначениеНастройки("сабИгнорироватьБлокировкуАвтообновленийДокументов");
	Если Не ИгнорироватьБлокАвтообновления Тогда
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"Объект") Тогда	 
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект,"АвтообновленияЗаблокированы") Тогда
				Если Форма.Элементы.Найти("АвтообновленияЗаблокированы") = Неопределено Тогда
					Если Форма.Элементы.Найти("ГруппаКомментарийОтветственный") <> Неопределено Тогда
						НовыйЭлемент = Форма.Элементы.Добавить("АвтообновленияЗаблокированы", Тип("ПолеФормы"),Форма.Элементы.ГруппаКомментарийОтветственный);
						НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
						НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
						НовыйЭлемент.ВидФлажка = ВидФлажка.Выключатель;
						НовыйЭлемент.ПутьКДанным = "Объект.АвтообновленияЗаблокированы";
					ИначеЕсли Форма.Элементы.Найти("ГруппаПодвал") <> Неопределено Тогда
						НовыйЭлемент = Форма.Элементы.Добавить("АвтообновленияЗаблокированы", Тип("ПолеФормы"),Форма.Элементы.ГруппаПодвал);
						НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
						НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
						НовыйЭлемент.ВидФлажка = ВидФлажка.Выключатель;
						НовыйЭлемент.ПутьКДанным = "Объект.АвтообновленияЗаблокированы";
					Иначе
						НовыйЭлемент = Форма.Элементы.Добавить("АвтообновленияЗаблокированы", Тип("ПолеФормы"));
						НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
						НовыйЭлемент.Вид = ВидПоляФормы.ПолеФлажка;
						НовыйЭлемент.ВидФлажка = ВидФлажка.Выключатель;
						НовыйЭлемент.ПутьКДанным = "Объект.АвтообновленияЗаблокированы";
					КонецЕсли;
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"Объект") Тогда	 
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект,"ВидСкладаДляВыгрузки") Тогда
			Если Форма.Элементы.Найти("ВидСкладаДляВыгрузки") = Неопределено Тогда
				НовыйЭлемент = Форма.Элементы.Добавить("ВидСкладаДляВыгрузки", Тип("ПолеФормы"));
				НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
				НовыйЭлемент.КнопкаВыпадающегоСписка = Истина;
				НовыйЭлемент.СписокВыбора.Добавить("Основной");
				НовыйЭлемент.СписокВыбора.Добавить("Склад ответственного хранения");
				НовыйЭлемент.СписокВыбора.Добавить("Товар в пути");
				НовыйЭлемент.СписокВыбора.Добавить("Брак");
				НовыйЭлемент.СписокВыбора.Добавить("Резерв");
				НовыйЭлемент.РедактированиеТекста = Ложь; 
				НовыйЭлемент.КнопкаОчистки = Истина;
				НовыйЭлемент.ПутьКДанным = "Объект.ВидСкладаДляВыгрузки";
			КонецЕсли; 
		КонецЕсли;	
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект,"АдресСкладаДляВыгрузки") Тогда
			Если Форма.Элементы.Найти("АдресСкладаДляВыгрузки") = Неопределено Тогда
				НовыйЭлемент = Форма.Элементы.Добавить("АдресСкладаДляВыгрузки", Тип("ПолеФормы"));
				НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
				НовыйЭлемент.КнопкаОчистки = Истина;
				НовыйЭлемент.ПутьКДанным = "Объект.АдресСкладаДляВыгрузки";
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	
	Если Форма.ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора" Тогда
		Если Форма.Параметры.Свойство("СопоставлениеИзПриемкиВыборНоменклатурыБезГруппДляФормыСопоставления") Тогда
			Если Параметры.СопоставлениеИзПриемкиВыборНоменклатурыБезГруппДляФормыСопоставления Тогда
			Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 


