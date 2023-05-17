﻿
&Перед("ПриЧтенииНаСервере")
Процедура УУ_ПриЧтенииНаСервере(Форма, ТекущийОбъект)
	
	//если есть УУ док
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.сабОбработкаДокументов) Тогда
		Возврат;	
	КонецЕсли;
	
	Если Не СтрНайти(Строка(ТипЗнч(ТекущийОбъект)), "Документ объект:") Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Ссылка) Тогда
		
		Если Форма.Элементы.Найти("ГруппаДокументУУ") = Неопределено Тогда
			Группа = Форма.Элементы.Добавить("ГруппаДокументУУ", Тип("ГруппаФормы"), Форма);
			Группа.Заголовок = "Документы УУ";
			Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			Группа.Поведение  = ПоведениеОбычнойГруппы.Свертываемая;
			Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
			Группа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
			Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
		Иначе
			Группа = Форма.Элементы.ГруппаДокументУУ;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДокументБУ.Установить(ТекущийОбъект.Ссылка);
		НаборЗаписей.Прочитать();
		Для каждого ТекЗапись Из НаборЗаписей Цикл
			
			Если Не ЗначениеЗаполнено(ТекЗапись.ДокументБУ) Или Не ЗначениеЗаполнено(ТекЗапись.ДокументУУ) Тогда
				Продолжить;
			КонецЕсли;
			
			ДобавляемыеРеквизиты	= Новый Массив;
			
			Массив = Новый Массив;
			Массив.Добавить(ТипЗнч(ТекЗапись.ДокументУУ));
			ОписаниеТиповС = Новый ОписаниеТипов(Массив);
			
			Если Не БюджетныйНаСервере.ЕстьСвойствоОбъекта(Форма, "ДокументУУ") Тогда
				Реквизит_ДокументБУ = Новый РеквизитФормы("ДокументУУ",	ОписаниеТиповС,	, "Документ УУ");
				ДобавляемыеРеквизиты.Добавить(Реквизит_ДокументБУ);
				Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
			КонецЕсли;	
			
			Если Форма.Элементы.Найти("ДокументУУ") = Неопределено Тогда
				НовыйЭлемент = Форма.Элементы.Добавить("ДокументУУ", Тип("ПолеФормы"), Группа);
				НовыйЭлемент.ПутьКДанным                  = "ДокументУУ";
				НовыйЭлемент.Вид                          = ВидПоляФормы.ПолеНадписи;
				НовыйЭлемент.Гиперссылка 				  = Истина;
			КонецЕсли;
			
			Форма.ДокументУУ = ТекЗапись.ДокументУУ;
			
			Прервать;
			
		КонецЦикла;
		
		ДокМета = ТекущийОбъект.Ссылка.Метаданные();
		Если Не ДокМета.Реквизиты.Найти("Заказ") = Неопределено И Форма.Элементы.Найти("сабЗаказ") = Неопределено Тогда
			ПолеВвода = Форма.Элементы.Добавить("сабЗаказ", Тип("ПолеФормы"), Группа);
			ПолеВвода.Заголовок = "Заказ";
			ПолеВвода.Вид = ВидПоляФормы.ПолеНадписи;
			ПолеВвода.ГиперСсылка = Истина;
			ПолеВвода.ПутьКДанным = "Объект.Заказ";
			ПолеВвода.Видимость = ЗначениеЗаполнено(ТекущийОбъект.Заказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
