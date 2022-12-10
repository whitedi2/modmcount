﻿
&Перед("ПриЧтенииНаСервере")
Процедура УУ_ПриЧтенииНаСервере(Форма, ТекущийОбъект)
	
	//если есть УУ док
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.сабОбработкаДокументов) Тогда
		Возврат;	
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоДокумент(ТекущийОбъект.Метаданные()) Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Ссылка) Тогда
		
		НаборЗаписей = РегистрыСведений.сабОбработкаДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДокументБУ.Установить(ТекущийОбъект.Ссылка);
		НаборЗаписей.Прочитать();
		Для каждого ТекЗапись Из НаборЗаписей Цикл
			
			ДобавляемыеРеквизиты	= Новый Массив;
			
			Массив = Новый Массив;
			Массив.Добавить(ТипЗнч(ТекЗапись.ДокументУУ));
			ОписаниеТиповС = Новый ОписаниеТипов(Массив);
			
			Если Не БюджетныйНаСервере.ЕстьСвойствоОбъекта(Форма, "ДокументУУ") Тогда
				Реквизит_ДокументБУ = Новый РеквизитФормы("ДокументУУ",	ОписаниеТиповС,	, "Документ УУ");
				ДобавляемыеРеквизиты.Добавить(Реквизит_ДокументБУ);
				Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
			КонецЕсли;	
			
			Если Форма.Элементы.Найти("ГруппаДокументУУ") = Неопределено Тогда
				
				Группа = Форма.Элементы.Добавить(
				"ГруппаДокументУУ",
				Тип("ГруппаФормы"),
				Форма);
				
				Группа.Заголовок = "Документ УУ";
				Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
				Группа.Поведение  = ПоведениеОбычнойГруппы.Свертываемая;
				Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
				Группа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
				Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
				
				НовыйЭлемент = Форма.Элементы.Добавить("ДокументУУ", Тип("ПолеФормы"), Группа);
				НовыйЭлемент.ПутьКДанным                  = "ДокументУУ";
				НовыйЭлемент.Вид                          = ВидПоляФормы.ПолеНадписи;
				НовыйЭлемент.Гиперссылка 				  = Истина;
				
				Форма.ДокументУУ = ТекЗапись.ДокументУУ;
				
			КонецЕсли;
			
			Прервать;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
